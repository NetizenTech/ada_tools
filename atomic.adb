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

with System;
with System.Machine_Code; use System.Machine_Code;

package body Atomic is

   NL : constant String := ASCII.LF & ASCII.HT;

   -- Atomic_8
   procedure xchg_8 (ptr : access Atomic_8; val : in Unsigned_8) is
   begin
      Asm (Template => "lock xchgb (%1), %0",
           Inputs   => (Unsigned_8'Asm_Input ("r", val),
                        System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
   end xchg_8;

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

   function cmpxchg_8 (ptr : access Atomic_8; xchg : in Unsigned_8; cmp : in Unsigned_8) return Boolean is
      x : Boolean;
   begin
      Asm (Template => "movb %1, %%al"          & NL &
                       "lock cmpxchgb %2, (%3)" & NL &
                       "sete %0",
           Outputs  => (Boolean'Asm_Output ("=r", x)),
           Inputs   => (Unsigned_8'Asm_Input ("r", cmp),
                        Unsigned_8'Asm_Input ("r", xchg),
                        System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
      return x;
   end cmpxchg_8;

   -- Atomic_32
   procedure xchg_32 (ptr : access Atomic_32; val : in Unsigned_32) is
   begin
      Asm (Template => "lock xchgl (%1), %0",
           Inputs   => (Unsigned_32'Asm_Input ("r", val),
                        System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
   end xchg_32;

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

   function cmpxchg_32 (ptr : access Atomic_32; xchg : in Unsigned_32; cmp : in Unsigned_32) return Boolean is
      x : Boolean;
   begin
      Asm (Template => "movl %1, %%eax"         & NL &
                       "lock cmpxchgl %2, (%3)" & NL &
                       "sete %0",
           Outputs  => (Boolean'Asm_Output ("=r", x)),
           Inputs   => (Unsigned_32'Asm_Input ("r", cmp),
                        Unsigned_32'Asm_Input ("r", xchg),
                        System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
      return x;
   end cmpxchg_32;

   -- Atomic_64
   procedure xchg_64 (ptr : access Atomic_64; val : in Unsigned_64) is
   begin
      Asm (Template => "lock xchgq (%1), %0",
           Inputs   => (Unsigned_64'Asm_Input ("r", val),
                        System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
   end xchg_64;

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

   function cmpxchg_64 (ptr : access Atomic_64; xchg : in Unsigned_64; cmp : in Unsigned_64) return Boolean is
      x : Boolean;
   begin
      Asm (Template => "movq %1, %%rax"         & NL &
                       "lock cmpxchgq %2, (%3)" & NL &
                       "sete %0",
           Outputs  => (Boolean'Asm_Output ("=r", x)),
           Inputs   => (Unsigned_64'Asm_Input ("r", cmp),
                        Unsigned_64'Asm_Input ("r", xchg),
                        System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
      return x;
   end cmpxchg_64;

   -- Atomic 8b
   function cmpxchg_8b (ptr : access Atomic_32; args : access args_8b) return Boolean is
      x : Boolean;
   begin
      Asm (Template => "movl %1, %%eax"       & NL &
                       "movl %2, %%edx"       & NL &
                       "movl %3, %%ebx"       & NL &
                       "movl %4, %%ecx"       & NL &
                       "lock cmpxchg8b (%5)" & NL &
                       "sete %0",
           Outputs  => (Boolean'Asm_Output ("=r", x)),
           Inputs   => (Unsigned_32'Asm_Input ("m", args.c1),
                        Unsigned_32'Asm_Input ("m", args.c2),
                        Unsigned_32'Asm_Input ("m", args.x1),
                        Unsigned_32'Asm_Input ("m", args.x2),
                        System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
      return x;
   end cmpxchg_8b;

   -- Atomic 16b
   function cmpxchg_16b (ptr : access Atomic_64; args : access args_16b) return Boolean is
      x : Boolean;
   begin
      Asm (Template => "movq %1, %%rax"       & NL &
                       "movq %2, %%rdx"       & NL &
                       "movq %3, %%rbx"       & NL &
                       "movq %4, %%rcx"       & NL &
                       "lock cmpxchg16b (%5)" & NL &
                       "sete %0",
           Outputs  => (Boolean'Asm_Output ("=r", x)),
           Inputs   => (Unsigned_64'Asm_Input ("m", args.c1),
                        Unsigned_64'Asm_Input ("m", args.c2),
                        Unsigned_64'Asm_Input ("m", args.x1),
                        Unsigned_64'Asm_Input ("m", args.x2),
                        System.Address'Asm_Input ("r", ptr.all'Address)),
           Volatile => True);
      return x;
   end cmpxchg_16b;

end Atomic;
