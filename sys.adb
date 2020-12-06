-- Ada-program for Linux API. Coded by Wojciech Lawren.

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

package body sys is

   NL : constant String := ASCII.LF & ASCII.HT;

   procedure write (x : in String) is
      NR_write : constant := 1;
      fd       : constant := 1;
   begin
      Asm (Template => "movq %0, %%rsi" & NL &
                       "movl %1, %%edx" & NL &
                       "movl %2, %%edi" & NL &
                       "movl %3, %%eax" & NL &
                       "syscall",
           Inputs   => (System.Address'Asm_Input ("r", x'Address),
                        Integer'Asm_Input ("r", x'Length),
                        Integer'Asm_Input ("n", fd),
                        Integer'Asm_Input ("n", NR_write)),
           Volatile => True);
   end write;

   procedure nanosleep (t : access constant timespec) is
      NR_nanosleep : constant := 35;
   begin
      Asm (Template => "xorq %%rsi, %%rsi" & NL &
                       "movq %0, %%rdi"    & NL &
                       "movl %1, %%eax"    & NL &
                       "syscall",
           Inputs   => (System.Address'Asm_Input ("r", t.all'Address),
                        Integer'Asm_Input ("n", NR_nanosleep)),
           Volatile => True);
   end nanosleep;

   procedure exit0 (s : in Integer := 0) is
      NR_exit : constant := 60;
   begin
      Asm (Template => "movl %0, %%edi" & NL &
                       "movl %1, %%eax" & NL &
                       "syscall",
           Inputs   => (Integer'Asm_Input ("r", s),
                        Integer'Asm_Input ("n", NR_exit)),
           Volatile => True);
   end exit0;

   function futex (f : access Atomic_32; op : in Integer; val : in Unsigned_32) return Integer is
      NR_futex : constant := 202;
      x : Integer;
   begin
      Asm (Template => "xorq %%r10, %%r10" & NL &
                       "movq %1, %%rdi"    & NL &
                       "movl %2, %%esi"    & NL &
                       "movl %3, %%edx"    & NL &
                       "movl %4, %%eax"    & NL &
                       "syscall"           & NL &
                       "movl %%eax, %0",
           Outputs  => (Integer'Asm_Output ("=r", x)),
           Inputs   => (System.Address'Asm_Input ("r", f.all'Address),
                        Integer'Asm_Input ("r", op),
                        Unsigned_32'Asm_Input ("r", val),
                        Integer'Asm_Input ("n", NR_futex)),
           Volatile => True);
      return x;
   end futex;

   procedure futex_lock (f : access lock_t) is
   begin
      loop
         exit when cmpxchg_32 (f.f1'Access, 0, 1) = 1;
         case futex (f.f1'Access, FUTEX_WAIT, 0) is
            when 0 | -11 => null;
            when others  => exit0 (-1);
         end case;
      end loop;
   end futex_lock;

   procedure futex_unlock (f : access lock_t) is
   begin
      case cmpxchg_32 (f.f1'Access, 1, 0) is
         when 0      =>
            case futex (f.f1'Access, FUTEX_WAKE, 1) is
               when 0 | 1  => null;
               when others => exit0 (-1);
            end case;
         when others => exit0 (-1);
      end case;
   end futex_unlock;

   procedure fast_lock (f : access lock_t) is
      procedure pthread_yield with Import;
   begin
      loop
         exit when cmpxchg_32 (f.f2'Access, 0, 1) = 1;
         pthread_yield;
      end loop;
   end fast_lock;

   procedure fast_unlock (f : access lock_t) is
   begin
      case cmpxchg_32 (f.f2'Access, 1, 0) is
         when 0      => null;
         when others => exit0 (-1);
      end case;
   end fast_unlock;

   procedure queue_lock (f : access lock_t) is
      procedure pthread_yield with Import;
      x : constant Unsigned_32 := xadd_32 (f.q1'Access, 2);
   begin
      loop
         exit when cmpxchg_32 (f.f3'Access, 0, x) = x;
         pthread_yield;
      end loop;
   end queue_lock;

   procedure queue_lock (f : access lock_t; t : access constant timespec) is
      x : constant Unsigned_32 := xadd_32 (f.q1'Access, 2);
   begin
      loop
         exit when cmpxchg_32 (f.f3'Access, 0, x) = x;
         nanosleep (t);
      end loop;
   end queue_lock;

   procedure queue_unlock (f : access lock_t) is
      x : constant Unsigned_32 := xadd_32p (f.q2'Access, 2);
   begin
      case cmpxchg_32 (f.f3'Access, x, 0) is
         when 0      => null;
         when others => exit0 (-1);
      end case;
   end queue_unlock;

   procedure pause34 is
      NR_pause : constant := 34;
   begin
      Asm (Template => "movl %0, %%eax" & NL &
                       "syscall",
           Inputs   => (Integer'Asm_Input ("n", NR_pause)),
           Volatile => True);
   end pause34;

   function getpid return pid_t is
      NR_getpid : constant := 39;
      x : pid_t;
   begin
      Asm (Template => "movl %1, %%eax" & NL &
                       "syscall"        & NL &
                       "movl %%eax, %0",
           Outputs  => (pid_t'Asm_Output ("=r", x)),
           Inputs   => (Integer'Asm_Input ("n", NR_getpid)),
           Volatile => True);
      return x;
   end getpid;

   function gettid return pid_t is
      NR_gettid : constant := 186;
      x : pid_t;
   begin
      Asm (Template => "movl %1, %%eax" & NL &
                       "syscall"        & NL &
                       "movl %%eax, %0",
           Outputs  => (pid_t'Asm_Output ("=r", x)),
           Inputs   => (Integer'Asm_Input ("n", NR_gettid)),
           Volatile => True);
      return x;
   end gettid;

   function tgkill (tgid : in pid_t; tid : in pid_t; sig : in Integer) return Integer is
      NR_tgkill : constant := 234;
      x : Integer;
   begin
      Asm (Template => "movl %1, %%edi" & NL &
                       "movl %2, %%esi" & NL &
                       "movl %3, %%edx" & NL &
                       "movl %4, %%eax" & NL &
                       "syscall"        & NL &
                       "movl %%eax, %0",
           Outputs  => (Integer'Asm_Output ("=r", x)),
           Inputs   => (pid_t'Asm_Input ("r", tgid),
                        pid_t'Asm_Input ("r", tid),
                        Integer'Asm_Input ("r", sig),
                        Integer'Asm_Input ("n", NR_tgkill)),
           Volatile => True);
      return x;
   end tgkill;

end sys;
