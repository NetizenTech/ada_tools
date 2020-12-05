-- Atomic functions. Coded by Wojciech Lawren.

-- Copyright (C) 2020, Wojciech Lawren, All rights reserved.

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
-- INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
-- SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
-- SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
-- WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
-- USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

-- References:
--    April 2020 AMD64 Architecture Programmer's Manual

-- all memory values are initialized to zero:

-- 1.
-- Processor 0             Processor 1
-- Store A <- 1            Store B <- 1
-- Load B                  Load A

-- All combinations of values (00, 01, 10, and 11) may be observed by Processors 0 and 1

-- 2.
-- Processor 0             Processor 1
-- Store A <- 1            Store B <- 1
-- MFENCE                  MFENCE
-- Load B                  Load A

-- Load A and Load B cannot both read 0
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

   function xadd_32 (ptr : access Atomic_32; val : in Unsigned_32) return Unsigned_32 with No_Inline;

   function xadd_32p (ptr : access Atomic_32; val : in Unsigned_32) return Unsigned_32 with No_Inline;

   procedure dec_32 (ptr : access Atomic_32) with No_Inline;

   procedure store_32 (ptr : access Atomic_32; val : in Unsigned_32) with No_Inline;

   function cmpxchg_32 (ptr : access Atomic_32; xchg : in Unsigned_32; cmp : in Unsigned_32) return Unsigned_32 with No_Inline;

   function load_32if8 (ptr : access Atomic_32; p8 : access Atomic_8; val : in Unsigned_8) return Unsigned_32 with No_Inline;

   function cmpxchg_8 (ptr : access Atomic_8; xchg : in Unsigned_8; cmp : in Unsigned_8) return Unsigned_8 with No_Inline;

   procedure store_8 (ptr : access Atomic_8; val : in Unsigned_8) with No_Inline;

end Atomic;
