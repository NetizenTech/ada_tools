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

   generic
      val : Unsigned_32;
   function xadd_32 (ptr : access Atomic_32) return Unsigned_32 with
      Inline_Always;

   generic
      val : Unsigned_32;
   function xadd_32p (ptr : access Atomic_32) return Unsigned_32 with
      Inline_Always;

   generic
   procedure dec_32 (ptr : access Atomic_32) with
      Inline_Always;

   generic
      val : Unsigned_32;
   procedure store_32 (ptr : access Atomic_32) with
      Inline_Always;

   generic
      val : Unsigned_8;
   function load_32if8 (ptr : access Atomic_32; p8 : access Atomic_8) return Unsigned_32 with
      Inline_Always;

   generic
      cmp  : Unsigned_8;
      xchg : Unsigned_8;
   function cmpxchg_8 (ptr : access Atomic_8) return Boolean with
      Inline_Always;

   generic
      val : Unsigned_8;
   procedure store_8 (ptr : access Atomic_8) with
      Inline_Always;

end Atomic;
