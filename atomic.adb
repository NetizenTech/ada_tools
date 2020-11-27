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

with System;
with System.Machine_Code; use System.Machine_Code;

package body Atomic is

   NL : constant String := ASCII.LF & ASCII.HT;

   function xadd_32 (ptr : access Atomic_32) return Unsigned_32 is
      x : Unsigned_32;
   begin
      Asm (Template => "lock xaddl %1, (%2)" & NL &
                       "movl %1, %0",
           Outputs  => (Unsigned_32'Asm_Output ("=r", x)),
           Inputs   => (Unsigned_32'Asm_Input ("r", val),
                        System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
      return x;
   end xadd_32;

   function xadd_32p (ptr : access Atomic_32) return Unsigned_32 is
      function x is new xadd_32 (val);
   begin
      return (x (ptr) + val);
   end xadd_32p;

   procedure dec_32 (ptr : access Atomic_32) is
   begin
      Asm (Template => "lock decl (%0)",
           Inputs   => (System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
   end dec_32;

   procedure store_32 (ptr : access Atomic_32) is
   begin
      Asm (Template => "lock xchgl (%1), %0",
           Inputs   => (Unsigned_32'Asm_Input ("r", val),
                        System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
   end store_32;

   function load_32if8 (ptr : access Atomic_32; p8 : access Atomic_8) return Unsigned_32 is
      x : Unsigned_32;
      y : Unsigned_8;
   begin
      Asm (Template => "movl (%2), %0" & NL &
                       "lfence"        & NL &
                       "movb (%3), %1",
           Outputs  => (Unsigned_32'Asm_Output ("=r", x),
                        Unsigned_8'Asm_Output ("=r", y)),
           Inputs   => (System.Address'Asm_Input ("r", ptr.all'Address),
                        System.Address'Asm_Input ("r", p8.all'Address)),
           Volatile => True);
      if y = val then return x; end if;
      return 0;
   end load_32if8;

   function cmpxchg_8 (ptr : access Atomic_8) return Unsigned_8 is
      x : Unsigned_8;
   begin
      Asm (Template => "movb %1, %%al"            & NL &
                       "movb %2, %%dl"            & NL &
                       "lock cmpxchgb %%dl, (%3)" & NL &
                       "movb %%al, %0",
           Outputs  => (Unsigned_8'Asm_Output ("=r", x)),
           Inputs   => (Unsigned_8'Asm_Input ("n", cmp),
                        Unsigned_8'Asm_Input ("n", xchg),
                        System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
      return x;
   end cmpxchg_8;

   procedure store_8 (ptr : access Atomic_8) is
   begin
      Asm (Template => "lock xchgb (%1), %0",
           Inputs   => (Unsigned_8'Asm_Input ("r", val),
                        System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
   end store_8;

end Atomic;
