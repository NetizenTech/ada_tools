-- Ada-program for atomic mutexes. Coded by Wojciech Lawren.

-- Copyright (C) 2020, Wojciech Lawren, All rights reserved.

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
-- INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
-- SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
-- SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
-- WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
-- USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
pragma Ada_2020;

with System.Machine_Code; use System.Machine_Code;
with sys;                 use sys;

package body mutex is

   NL : constant String := ASCII.LF & ASCII.HT;

   function futex_lock (f : access lock_t) return Integer is
   begin
      loop
         exit when cmpxchg_32 (f.f3'Access, 0, 1);
         case futex (f.f3'Access, FUTEX_WAIT, 0) is
            when 0 | -11 => null;
            when others  => return (-1);
         end case;
      end loop;
      return 0;
   end futex_lock;

   function futex_unlock (f : access lock_t) return Integer is
   begin
      if cmpxchg_32 (f.f3'Access, 1, 0) then
         case futex (f.f3'Access, FUTEX_WAKE, 1) is
            when 0 | 1  => return 0;
            when others => return (-1);
         end case;
      end if;
      return (-1);
   end futex_unlock;

   procedure fast_lock (f : access lock_t) is
   begin
      loop
         exit when cmpxchg_32 (f.f4'Access, 0, 1);
         sched_yield;
      end loop;
   end fast_lock;

   function fast_unlock (f : access lock_t) return Integer is
   begin
      if cmpxchg_32 (f.f4'Access, 1, 0) then
         return 0;
      end if;
      return (-1);
   end fast_unlock;

   procedure queue_lock (f : access lock_t) is
      x : constant Unsigned_64 := xadd_64 (f.f1.fq.v2'Access, 1);
   begin
      loop
         exit when cmpxchg_64 (f.f1.fq.v1'Access, 0, x);
         sched_yield;
      end loop;
   end queue_lock;

   function queue_unlock (f : access lock_t) return Integer is
      x : constant Unsigned_64 := xadd_64p (f.f1.q2'Access, 1);
   begin
      if cmpxchg_64 (f.f1.fq.v1'Access, x, 0) then
         return 0;
      end if;
      return (-1);
   end queue_unlock;

   function reset_queue (f : access lock_t) return Integer is
      a16 : aliased args_16b := (Unsigned_64 (f.f1.fq.v1), Unsigned_64 (f.f1.fq.v1), 1, 1);
   begin
      Asm ("movq %%rdi, %%r11", Volatile => True);
      if cmpxchg_16b (f.f1.fq'Access, a16'Access) then
         -- f.f1.q2
         Asm ("movl $1, %%eax" & NL & "lock xchgq 16(%%r11), %%rax", Volatile => True);
         return 0;
      end if;
      return (-1);
   end reset_queue;

   procedure sig_lock (f : access lock_t) is
      x : constant Unsigned_64 := xadd_64 (f.f2.fq.v2'Access, 1);
      i : constant Unsigned_8 := Unsigned_8'Mod (x);
   begin
      f.n2 (i) := gettid;
      loop
         exit when cmpxchg_64 (f.f2.fq.v1'Access, 0, x);
         pause;
      end loop;
      f.n2 (i) := pid_t'Last;
   end sig_lock;

   function sig_unlock (f : access lock_t) return Integer is
      x : constant Unsigned_64 := xadd_64p (f.f2.q2'Access, 1);
      i : constant Unsigned_8 := Unsigned_8'Mod (x);
   begin
      if cmpxchg_64 (f.f2.fq.v1'Access, x, 0) then
         case tgkill (getpid, f.n2 (i), SIG_WAKE) is
            when 0      => return 0;
            when -3     =>
               declare
                  a16 : aliased args_16b := (x, x, 1, 1);
               begin
                  if cmpxchg_16b (f.f2.fq'Access, a16'Access) then
                     xchg_64 (f.f2.q2'Access, 1);
                  end if;
               end;
               return 0;
            when others => return (-1);
         end case;
      end if;
      return (-1);
   end sig_unlock;

end mutex;
