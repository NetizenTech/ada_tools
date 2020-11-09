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
   function init_genrand64 (MX : access mtx_array; J : in UTHN) return Unsigned_64 is
      M : constant access mt_array := MX (J).mt'Access;

      procedure mtx_init with Convention => C;

      procedure mtx_init is
         mxt : aliased pthread_mutexattr_t;
      begin
         assert ( pthread_mutexattr_init (mxt'Access) );
         assert ( pthread_mutexattr_settype (mxt'Access, 1) );
         assert ( pthread_mutex_init (MX (J).mtx'Access, mxt'Access) );
      end mtx_init;
   begin
      assert ( pthread_once (MX (J).once'Access, mtx_init'Access) );

      M (0) := MX (J).seed;

      for i in UNN range 1 .. NN - 1 loop
         M (i) := (IM * (M (i - 1) xor Shift_Right (M (i - 1), 62)) + Unsigned_64 (i));
      end loop;

      return up_genrand64 (MX, J);
   end init_genrand64;

   -- generate NN words at one time
   function up_genrand64 (MX : access mtx_array; J : in UTHN) return Unsigned_64 is
      M : constant access mt_array := MX (J).mt'Access;
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

      store32 (MX (J).mti'Access);
      return genrand64 (M (0));
   end up_genrand64;

   -- generates a random number on [0, 2^64-1]-interval
   function genrand64 (M : access mtx_array; I : in UTHN) return Unsigned_64 is
      x : constant Unsigned_32 := xadd32 (M (I).mti'Access);
   begin
      case x is
         when 1 .. NN - 1 =>
            return genrand64 (M (I).mt (UNN (x)));
         when NN =>
            return up_genrand64 (M, I);
         when NI =>
            return init_genrand64 (M, I);
         when others =>
            return 0;
      end case;
   end genrand64;

   -- assert for pthread func
   procedure assert (r : in Integer) is
   begin if r /= 0 then pthread_exit; end if; end assert;

end MT19937;
