-- Ada-program for libpthread x86_64 (minimal). Coded by Wojciech Lawren.

-- Copyright (C) 2020, Wojciech Lawren, All rights reserved.

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
-- INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
-- SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
-- SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
-- WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
-- USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

-- References:
--    Free Software Foundation, Inc.
pragma Ada_2020;

with System;
with Interfaces; use Interfaces;
with sys_t;      use sys_t;

package pthread with
   No_Elaboration_Code_All,
   Pure
is
   -- Scheduler inheritance.
   PTHREAD_INHERIT_SCHED  : constant := 0;
   PTHREAD_EXPLICIT_SCHED : constant := 1;

   -- Detach state.
   PTHREAD_CREATE_JOINABLE : constant := 0;
   PTHREAD_CREATE_DETACHED : constant := 1;

   -- Thread identifiers.
   type pthread_t is new Unsigned_64;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:27

   -- Data structure of thread attribute *ATTR
   type anon1032_array1034 is array (0 .. 55) of aliased Unsigned_8 with
      Default_Component_Value => 0;
   type pthread_attr_t (discr : Unsigned_32 := 0) is record
      case discr is
         when 0 =>
            size  : aliased anon1032_array1034;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:58
         when others =>
            align : aliased Long_Integer;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:59
      end case;
   end record
   with Unchecked_Union;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:56

   -- Thread attribute handling.
   -- Initialize thread attribute *ATTR with default attributes
   --   (detachstate is PTHREAD_JOINABLE, scheduling policy is SCHED_OTHER,
   --    no user-provided stack).
   function pthread_attr_init
     (attr : access pthread_attr_t) return Integer  -- /usr/include/pthread.h:263
   with Import;

   -- Add information about the minimum stack size needed for the thread
   --   to be started.  This size must never be less than PTHREAD_STACK_MIN
   --   and must also not exceed the system limits.
   function pthread_attr_setstacksize
     (attr      : access pthread_attr_t;
      stacksize : in Unsigned_64) return Integer  -- /usr/include/pthread.h:351
   with Import;

   -- Thread created with attribute ATTR will be limited to run only on
   --   the processors represented in CPUSET.
   function pthread_attr_setaffinity_np
     (attr       : access pthread_attr_t;
      cpusetsize : in Unsigned_64 := (cpu_set_t'Size / 8);
      cpuset     : access constant cpu_set_t) return Integer  -- /usr/include/pthread.h:372
   with Import;

   -- Set scheduling inheritance mode in *ATTR according to INHERIT.
   function pthread_attr_setinheritsched
     (attr    : access pthread_attr_t;
      inherit : in Integer) return Integer  -- /usr/include/pthread.h:316
   with Import;

   -- Set scheduling policy in *ATTR according to POLICY.
   function pthread_attr_setschedpolicy
     (attr   : access pthread_attr_t;
      policy : in Integer) return Integer  -- /usr/include/pthread.h:307
   with Import;

   -- Set scheduling parameters (priority, etc) in *ATTR according to PARAM.
   function pthread_attr_setschedparam
     (attr  : access pthread_attr_t;
      param : access constant sched_param) return Integer  -- /usr/include/pthread.h:297
   with Import;

   -- Set detach state attribute.
   function pthread_attr_setdetachstate
     (attr        : access pthread_attr_t;
      detachstate : in Integer) return Integer  -- /usr/include/pthread.h:275
   with Import;

   -- Set the default attributes to be used by pthread_create in this process.
   function pthread_setattr_default_np
     (attr : access constant pthread_attr_t) return Integer  -- /usr/include/pthread.h:390
   with Import;

   -- Functions for handling initialization.
   -- Create a new thread, starting with execution of START-ROUTINE
   --   getting passed ARG.  Creation attributed come from ATTR.  The new
   --   handle is stored in *NEWTHREAD.
   function pthread_create
     (thread : access pthread_t;
      attr   : access constant pthread_attr_t := null;
      start  : in System.Address;
      arg    : in System.Address := System.Null_Address) return Integer  -- /usr/include/pthread.h:198
   with Import;

   -- Make calling thread wait for termination of the thread TH.  The
   --   exit status of the thread is stored in *THREAD_RETURN, if THREAD_RETURN
   --   is not NULL.
   function pthread_join
     (thread : in pthread_t;
      retval : in System.Address := System.Null_Address) return Integer  -- /usr/include/pthread.h:215
   with Import;

   -- Limit specified thread TH to run only on the processors represented
   --   in CPUSET.
   function pthread_setaffinity_np
     (thread     : in pthread_t;
      cpusetsize : in Unsigned_64 := (cpu_set_t'Size / 8);
      cpuset     : access constant cpu_set_t) return Integer -- /usr/include/pthread.h:450
   with Import;

   -- Functions for scheduling control.
   -- Set the scheduling parameters for TARGET_THREAD according to POLICY
   --   and *PARAM.
   function pthread_setschedparam
     (thread : in pthread_t;
      policy : in Integer;
      param  : access constant sched_param) return Integer  -- /usr/include/pthread.h:405
   with Import;

   -- Set the scheduling priority for TARGET_THREAD.
   function pthread_setschedprio
    (thread : in pthread_t;
     prio   : in Integer) return Integer  -- /usr/include/pthread.h:416
   with Import;

   -- Indicate that the thread TH is never to be joined with PTHREAD_JOIN.
   --   The resources of TH will therefore be freed immediately when it
   --   terminates, instead of waiting for another thread to perform PTHREAD_JOIN
   --   on it.
   function pthread_detach
     (thread : in pthread_t) return Integer  -- /usr/include/pthread.h:247
   with Import;

   -- Yield the processor to another thread or process.
   --   This function is similar to the POSIX `sched_yield' function but
   --   might be differently implemented in the case of a m-on-n thread
   --   implementation. On Linux, this call always succeeds.
   procedure pthread_yield  -- /usr/include/pthread.h:445
   with Import;

   -- Obtain the identifier of the current thread.
   function pthread_self return pthread_t  -- /usr/include/pthread.h:251
   with Import;

   -- Terminate calling thread.
   procedure pthread_exit
     (retval : in System.Address := System.Null_Address)  -- /usr/include/pthread.h:207
   with Import;

end pthread;
