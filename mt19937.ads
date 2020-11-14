-- Ada-program for MT19937-64. Coded by Wojciech Lawren.

-- This is MT 64-bit version of Mersenne Twister pseudorandom number generator.

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

with Atomic;        use Atomic;
with Interfaces;    use Interfaces;
with pthread_mutex; use pthread_mutex;

package MT19937 with
   No_Elaboration_Code_All,
   Pure
is
   DIM      : constant := 1;
   ADT      : constant := 1;
   THN      : constant := 32  * DIM;
   MM       : constant := 156 * ADT;
   NN       : constant := 312 * ADT;
   NI       : constant := 16#186A1#;
   UM       : constant Unsigned_64 := 16#FFFF_FFFF_8000_0000#; -- Most significant 33 bits
   LM       : constant Unsigned_64 := 16#7FFF_FFFF#;           -- Least significant 31 bits
   IM       : constant Unsigned_64 := 16#5851_F42D_4C95_7F2D#;
   SD       : constant Unsigned_64 := 16#153D#;
   MATRIX_A : constant array (Unsigned_64 range 0 .. 1) of Unsigned_64 := (16#0#, 16#B502_6F5A_A966_19E9#);

   -- atomic's
   function xadd32 is new xadd_32 (1);

   procedure store32 is new store_32 (1);

   procedure reset is new store_32 (NI);

   type UNN is mod NN + 1 with
      Size          => 32,
      Default_Value => 0;

   type UTHN is mod THN with
      Size          => 32,
      Default_Value => 0;

   type mt_array is array (UNN range 0 .. NN - 1) of Unsigned_64 with
      Default_Component_Value => 0;

   type Matrix is limited record
      mt   : aliased mt_array;             -- The array for the state vector
      mti  : aliased Atomic_32 := NI;      -- mti==NI means mt[NN] is not initialized
      seed : aliased Unsigned_64 := SD;    -- initial value
      mtx  : aliased pthread_mutex_t;      -- PTHREAD_MUTEX_RECURSIVE
   end record;

   type mtx_array is array (UTHN) of aliased Matrix;

   type mtx_switch is limited record
      idx : aliased Atomic_32;
      mtx : aliased mtx_array;
   end record;

   -- generates a random number on [0, 2^64-1]-interval
   function genrand64 (M : access mtx_array; I : in UTHN) return Unsigned_64;

private

   -- initializes mt[NN] with a seed
   function init_genrand64 (MX : access mtx_array; J : in UTHN) return Unsigned_64;

   -- generate NN words at one time
   function up_genrand64 (MX : access mtx_array; J : in UTHN) return Unsigned_64;

end MT19937;
