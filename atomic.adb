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

   function xadd_32 (ptr : access Atomic_32; val : in Unsigned_32) return Unsigned_32 is
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

   function xadd_32p (ptr : access Atomic_32; val : in Unsigned_32) return Unsigned_32 is
      x : Unsigned_32;
   begin
      Asm (Template => "movl %1, %0"         & NL &
                       "lock xaddl %1, (%2)" & NL &
                       "addl %1, %0",
           Outputs  => (Unsigned_32'Asm_Output ("=r", x)),
           Inputs   => (Unsigned_32'Asm_Input ("r", val),
                        System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
      return x;
   end xadd_32p;

   procedure dec_32 (ptr : access Atomic_32) is
   begin
      Asm (Template => "lock decl (%0)",
           Inputs   => (System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
   end dec_32;

   procedure store_32 (ptr : access Atomic_32; val : in Unsigned_32) is
   begin
      Asm (Template => "lock xchgl (%1), %0",
           Inputs   => (Unsigned_32'Asm_Input ("r", val),
                        System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
   end store_32;

   function cmpxchg_32 (ptr : access Atomic_32; xchg : in Unsigned_32; cmp : in Unsigned_32) return Unsigned_32 is
      x : Unsigned_32;
   begin
      Asm (Template => "movl %1, %%eax"         & NL &
                       "lock cmpxchgl %2, (%3)" & NL &
                       "movl %%eax, %0",
           Outputs  => (Unsigned_32'Asm_Output ("=r", x)),
           Inputs   => (Unsigned_32'Asm_Input ("r", cmp),
                        Unsigned_32'Asm_Input ("r", xchg),
                        System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
      return x;
   end cmpxchg_32;

   function cmpxchg_8 (ptr : access Atomic_8; xchg : in Unsigned_8; cmp : in Unsigned_8) return Unsigned_8 is
      x : Unsigned_8;
   begin
      Asm (Template => "movb %1, %%al"          & NL &
                       "lock cmpxchgb %2, (%3)" & NL &
                       "movb %%al, %0",
           Outputs  => (Unsigned_8'Asm_Output ("=r", x)),
           Inputs   => (Unsigned_8'Asm_Input ("r", cmp),
                        Unsigned_8'Asm_Input ("r", xchg),
                        System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
      return x;
   end cmpxchg_8;

   procedure store_8 (ptr : access Atomic_8; val : in Unsigned_8) is
   begin
      Asm (Template => "lock xchgb (%1), %0",
           Inputs   => (Unsigned_8'Asm_Input ("r", val),
                        System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
   end store_8;

   function xadd_8 (ptr : access Atomic_8; val : in Unsigned_8) return Unsigned_8 is
      x : Unsigned_8;
   begin
      Asm (Template => "lock xaddb %1, (%2)" & NL &
                       "movb %1, %0",
           Outputs  => (Unsigned_8'Asm_Output ("=r", x)),
           Inputs   => (Unsigned_8'Asm_Input ("r", val),
                        System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
      return x;
   end xadd_8;

   function xadd_8p (ptr : access Atomic_8; val : in Unsigned_8) return Unsigned_8 is
      x : Unsigned_8;
   begin
      Asm (Template => "movb %1, %0"         & NL &
                       "lock xaddb %1, (%2)" & NL &
                       "addb %1, %0",
           Outputs  => (Unsigned_8'Asm_Output ("=r", x)),
           Inputs   => (Unsigned_8'Asm_Input ("r", val),
                        System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
      return x;
   end xadd_8p;

   function xadd_64 (ptr : access Atomic_64; val : in Unsigned_64) return Unsigned_64 is
      x : Unsigned_64;
   begin
      Asm (Template => "lock xaddq %1, (%2)" & NL &
                       "movq %1, %0",
           Outputs  => (Unsigned_64'Asm_Output ("=r", x)),
           Inputs   => (Unsigned_64'Asm_Input ("r", val),
                        System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
      return x;
   end xadd_64;

   function xadd_64p (ptr : access Atomic_64; val : in Unsigned_64) return Unsigned_64 is
      x : Unsigned_64;
   begin
      Asm (Template => "movq %1, %0"         & NL &
                       "lock xaddq %1, (%2)" & NL &
                       "addq %1, %0",
           Outputs  => (Unsigned_64'Asm_Output ("=r", x)),
           Inputs   => (Unsigned_64'Asm_Input ("r", val),
                        System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
      return x;
   end xadd_64p;

   procedure store_64 (ptr : access Atomic_64; val : in Unsigned_64) is
   begin
      Asm (Template => "lock xchgq (%1), %0",
           Inputs   => (Unsigned_64'Asm_Input ("r", val),
                        System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
   end store_64;

   function cmpxchg_64 (ptr : access Atomic_64; xchg : in Unsigned_64; cmp : in Unsigned_64) return Unsigned_64 is
      x : Unsigned_64;
   begin
      Asm (Template => "movq %1, %%rax"         & NL &
                       "lock cmpxchgq %2, (%3)" & NL &
                       "movq %%rax, %0",
           Outputs  => (Unsigned_64'Asm_Output ("=r", x)),
           Inputs   => (Unsigned_64'Asm_Input ("r", cmp),
                        Unsigned_64'Asm_Input ("r", xchg),
                        System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
      return x;
   end cmpxchg_64;

end Atomic;
