-- Ada-program for MT19937-64. Coded by Wojciech Lawren.

-- This is MP 64-bit version of Mersenne Twister pseudorandom number generator.

-- Copyright (C) 2020, Wojciech Lawren, All rights reserved.

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
-- INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
-- SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
-- SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
-- WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
-- USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

-- References:
-- T. Nishimura, ``Tables of 64-bit Mersenne Twisters''
--   ACM Transactions on Modeling and
--   Computer Simulation 10. (2000) 348--357.
-- M. Matsumoto and T. Nishimura,
--   ``Mersenne Twister: a 623-dimensionally equidistributed
--     uniform pseudorandom number generator''
--   ACM Transactions on Modeling and
--   Computer Simulation 8. (Jan. 1998) 3--30.

-- Any feedback is very welcome.
pragma Ada_2020;

with MTavx; use MTavx;

package body MT19937 is

   -- initializes mt[NN] with a seed
   procedure init_genrand64 (M : access mt_array; S : in Unsigned_64) is
   begin
      M (0) := S;
      for i in UNN range 1 .. NN - 1 loop
         M (i) := (IM * (M (i - 1) xor Shift_Right (M (i - 1), 62)) + Unsigned_64 (i));
      end loop;
   end init_genrand64;

   -- generate NN words at one time
   procedure up_genrand64 (M : access mt_array) is
      x : Unsigned_64;
   begin
      for i in UNN range 0 .. NN - MM - 1 loop
         x     := (M (i) and UM) or (M (i + 1) and LM);
         M (i) := M (i + MM) xor Shift_Right (x, 1) xor MATRIX_A (x and 1);
      end loop;

      for i in UNN range MM .. NN - 2 loop
         x     := (M (i) and UM) or (M (i + 1) and LM);
         M (i) := M (i + (MM - NN)) xor Shift_Right (x, 1) xor MATRIX_A (x and 1);
      end loop;

      x          := (M (NN - 1) and UM) or (M (0) and LM);
      M (NN - 1) := M (MM - 1) xor Shift_Right (x, 1) xor MATRIX_A (x and 1);
   end up_genrand64;

   -- generates a random number on [0, 2^64-1]-interval
   function genrand64 (M : access mtx_array; I : in UTHN) return Unsigned_64 is
      x : constant Unsigned_32 := xadd32 (M (I).mti'Access);
   begin
      case x is
         when 1 .. NN - 1 =>
            return genrand64 (M (I).mt (UNN (x)));
         when NN =>
            if not (cmpxchg8 (M (I).mtf'Access)) then return queue_genrand64 (M, I); end if;
         when NN + 1 =>
            if not (cmpxchg8 (M (I).mtf'Access)) then return queue_genrand64 (M, I); end if;
            init_genrand64 (M (I).mt'Access, M (I).seed);
         when others =>
            return queue_genrand64 (M, I);
      end case;
      up_genrand64 (M (I).mt'Access);
      store8 (M (I).mtf'Access);
      store32 (M (I).mti'Access);
      return genrand64 (M (I).mt (0));
   end genrand64;

   -- far jump -> LIFO
   function queue_genrand64 (M : access mtx_array; I : in UTHN) return Unsigned_64 is
      x : constant Unsigned_32 := xadd32p (M (I).que'Access);
   begin
      loop
         delay Duration (Float ((THN * DIM - x) + 1) * DL);
         exit when (load32if8 (M (I).que'Access, M (I).mtf'Access) = x);
      end loop;
      dec32 (M (I).que'Access);
      return genrand64 (M, I);
   end queue_genrand64;

end MT19937;
