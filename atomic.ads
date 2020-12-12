-- Atomic functions. Coded by Wojciech Lawren.

-- Copyright (C) 2020, Wojciech Lawren, All rights reserved.

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
-- INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
-- SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
-- SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
-- WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
-- USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
pragma Ada_2020;

with Interfaces; use Interfaces;

package Atomic with
   No_Elaboration_Code_All,
   Pure
is
   type Atomic_8 is mod 2 ** 8 with
      Size          => 8,
      Default_Value => 0,
      Atomic;

   type Atomic_32 is mod 2 ** 32 with
      Size          => 32,
      Default_Value => 0,
      Atomic;

   type Atomic_64 is mod 2 ** 64 with
      Size          => 64,
      Default_Value => 0,
      Atomic;

   type ptr8b is limited record
      v1 : aliased Atomic_32 := 0;
      v2 : aliased Atomic_32 := 0;
   end record with Alignment => 8;

   type args_8b is limited record
      c1 : Unsigned_32 := 0;
      c2 : Unsigned_32 := 0;
      x1 : Unsigned_32 := 0;
      x2 : Unsigned_32 := 0;
   end record;

   type ptr16b is limited record
      v1 : aliased Atomic_64 := 0;
      v2 : aliased Atomic_64 := 0;
   end record with Alignment => 16;

   type args_16b is limited record
      c1 : Unsigned_64 := 0;
      c2 : Unsigned_64 := 0;
      x1 : Unsigned_64 := 0;
      x2 : Unsigned_64 := 0;
   end record;

   -- Atomic_8
   procedure xchg_8 (ptr : access Atomic_8; val : in Unsigned_8) with No_Inline;

   function xadd_8 (ptr : access Atomic_8; val : in Unsigned_8) return Unsigned_8 with No_Inline;

   function xadd_8p (ptr : access Atomic_8; val : in Unsigned_8) return Unsigned_8 with No_Inline;

   function cmpxchg_8 (ptr : access Atomic_8; xchg : in Unsigned_8; cmp : in Unsigned_8) return Boolean with No_Inline;

   -- Atomic_32
   procedure xchg_32 (ptr : access Atomic_32; val : in Unsigned_32) with No_Inline;

   function xadd_32 (ptr : access Atomic_32; val : in Unsigned_32) return Unsigned_32 with No_Inline;

   function xadd_32p (ptr : access Atomic_32; val : in Unsigned_32) return Unsigned_32 with No_Inline;

   function cmpxchg_32 (ptr : access Atomic_32; xchg : in Unsigned_32; cmp : in Unsigned_32) return Boolean with No_Inline;

   -- Atomic_64
   procedure xchg_64 (ptr : access Atomic_64; val : in Unsigned_64) with No_Inline;

   function xadd_64 (ptr : access Atomic_64; val : in Unsigned_64) return Unsigned_64 with No_Inline;

   function xadd_64p (ptr : access Atomic_64; val : in Unsigned_64) return Unsigned_64 with No_Inline;

   function cmpxchg_64 (ptr : access Atomic_64; xchg : in Unsigned_64; cmp : in Unsigned_64) return Boolean with No_Inline;

   -- Atomic 8b
   function cmpxchg_8b (ptr : access ptr8b; args : access constant args_8b) return Boolean with No_Inline;

   -- Atomic 16b
   function cmpxchg_16b (ptr : access ptr16b; args : access constant args_16b) return Boolean with No_Inline;

end Atomic;
