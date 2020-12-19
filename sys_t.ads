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

with Interfaces; use Interfaces;

package sys_t with
   No_Elaboration_Code_All,
   Pure
is
   -- Definitions of constants scheduling interface.
   SCHED_OTHER    : constant := 0;  --  /usr/include/x86_64-linux-gnu/bits/sched.h:28
   SCHED_FIFO     : constant := 1;  --  /usr/include/x86_64-linux-gnu/bits/sched.h:29
   SCHED_RR       : constant := 2;  --  /usr/include/x86_64-linux-gnu/bits/sched.h:30

   SIGUSR1 : constant := 10;
   SIGUSR2 : constant := 12;

   SIGRTMIN : constant := 34;
   SIGRTMAX : constant := 64;

   -- Size definition for CPU sets.
   CPU_SETSIZE : constant := 1_024;  -- /usr/include/x86_64-linux-gnu/bits/cpu-set.h
   SIG_SETSIZE : constant := 1_024;

   type pid_t is new Integer;

   -- Linux provides 99 realtime priority levels, numbered 1 (lowest) to 99 (highest).
   subtype Sched_Prio is Integer range 1 .. 99;

   -- Data structure to describe a process' schedulability.
   type sched_param is record
      sched_priority : aliased Sched_Prio;  -- /usr/include/x86_64-linux-gnu/bits/types/struct_sched_param.h:25
   end record;  -- /usr/include/x86_64-linux-gnu/bits/types/struct_sched_param.h:23

   -- Type for array elements in 'cpu_set_t'.
   type cpu_mask is new Unsigned_64;  -- /usr/include/x86_64-linux-gnu/bits/cpu-set.h:32

   -- Data structure to describe CPU mask.
   type cpu_set_t_array876 is array (0 .. ((CPU_SETSIZE / cpu_mask'Size) - 1)) of aliased cpu_mask with
      Default_Component_Value => 0;
   type cpu_set_t is record
      bits : aliased cpu_set_t_array876;  -- /usr/include/x86_64-linux-gnu/bits/cpu-set.h:41
   end record;  -- /usr/include/x86_64-linux-gnu/bits/cpu-set.h:42

   type sig_mask is new Unsigned_64;

   -- A set of signals to be blocked, unblocked, or waited for.
   type sigset_t_array868 is array (0 .. ((SIG_SETSIZE / sig_mask'Size) - 1)) of aliased sig_mask with
      Default_Component_Value => 0;
   type sigset_t is record
      val : aliased sigset_t_array868;  -- /usr/include/x86_64-linux-gnu/bits/types/__sigset_t.h:7
   end record;  -- /usr/include/x86_64-linux-gnu/bits/types/__sigset_t.h:8

end sys_t;
