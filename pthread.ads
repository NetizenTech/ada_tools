-- Ada-program for libpthread x86_64 (minimal). Coded by Wojciech Lawren.

-- Copyright (C) 2020, Wojciech Lawren, All rights reserved.

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
-- INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
-- SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
-- SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
-- WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
-- USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-- Ref:
--    Free Software Foundation, Inc.
pragma Ada_2020;

with System;
with Interfaces; use Interfaces;

package pthread with
   No_Elaboration_Code_All,
   Pure
is

   type anon1032_array1034 is array (0 .. 55) of aliased Unsigned_8;
   type pthread_attr_t (discr : Unsigned_32 := 0) is record
      case discr is
         when 0 =>
            uu_size  : aliased anon1032_array1034;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:58
         when others =>
            uu_align : aliased Long_Integer;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:59
      end case;
   end record
   with Unchecked_Union;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:56

   -- Data structure to describe a process' schedulability.
   type sched_param is record
      sched_priority : aliased Integer;  -- /usr/include/x86_64-linux-gnu/bits/types/struct_sched_param.h:25
   end record;  -- /usr/include/x86_64-linux-gnu/bits/types/struct_sched_param.h:23

   -- Thread attribute handling.
   -- Initialize thread attribute *ATTR with default attributes
   --   (detachstate is PTHREAD_JOINABLE, scheduling policy is SCHED_OTHER,
   --    no user-provided stack).
   function pthread_attr_init
     (uu_attr : access pthread_attr_t) return Integer  -- /usr/include/pthread.h:263
   with Import,
        Convention    => C,
        External_Name => "pthread_attr_init";

   -- Get the default attributes used by pthread_create in this process.
   function pthread_getattr_default_np
     (uu_attr : access pthread_attr_t) return Integer  -- /usr/include/pthread.h:385
   with Import,
        Convention    => C,
        External_Name => "pthread_getattr_default_np";

   -- Set the default attributes to be used by pthread_create in this process.
   function pthread_setattr_default_np
     (uu_attr : access constant pthread_attr_t) return Integer  -- /usr/include/pthread.h:390
   with Import,
        Convention    => C,
        External_Name => "pthread_setattr_default_np";

   -- Return the currently used minimal stack size.
   function pthread_attr_getstacksize
     (uu_attr      : access constant pthread_attr_t;
      uu_stacksize : access Unsigned_64) return Integer  -- /usr/include/pthread.h:344
   with Import,
        Convention    => C,
        External_Name => "pthread_attr_getstacksize";

   -- Add information about the minimum stack size needed for the thread
   --   to be started.  This size must never be less than PTHREAD_STACK_MIN
   --   and must also not exceed the system limits.
   function pthread_attr_setstacksize
     (uu_attr      : access pthread_attr_t;
      uu_stacksize : in Unsigned_64) return Integer  -- /usr/include/pthread.h:351
   with Import,
        Convention    => C,
        External_Name => "pthread_attr_setstacksize";

   -- Return in *PARAM the scheduling parameters of *ATTR.
   function pthread_attr_getschedparam
     (uu_attr  : access constant pthread_attr_t;
      uu_param : access sched_param) return Integer  -- /usr/include/pthread.h:292
   with Import,
        Convention    => C,
        External_Name => "pthread_attr_getschedparam";

   -- Set scheduling parameters (priority, etc) in *ATTR according to PARAM.
   function pthread_attr_setschedparam
     (uu_attr  : access pthread_attr_t;
      uu_param : access constant sched_param) return Integer  -- /usr/include/pthread.h:297
   with Import,
        Convention    => C,
        External_Name => "pthread_attr_setschedparam";

   -- Return in *POLICY the scheduling policy of *ATTR.
   function pthread_attr_getschedpolicy
     (uu_attr   : access constant pthread_attr_t;
      uu_policy : access Integer) return Integer  -- /usr/include/pthread.h:302
   with Import,
        Convention    => C,
        External_Name => "pthread_attr_getschedpolicy";

   -- Set scheduling policy in *ATTR according to POLICY.
   function pthread_attr_setschedpolicy
     (uu_attr   : access pthread_attr_t;
      uu_policy : in Integer) return Integer  -- /usr/include/pthread.h:307
   with Import,
        Convention    => C,
        External_Name => "pthread_attr_setschedpolicy";

   -- Get detach state attribute.
   function pthread_attr_getdetachstate
     (uu_attr        : access constant pthread_attr_t;
      uu_detachstate : access Integer) return Integer  -- /usr/include/pthread.h:270
   with Import,
        Convention    => C,
        External_Name => "pthread_attr_getdetachstate";

   -- Set detach state attribute.
   function pthread_attr_setdetachstate
     (uu_attr        : access pthread_attr_t;
      uu_detachstate : in Integer) return Integer  -- /usr/include/pthread.h:275
   with Import,
        Convention    => C,
        External_Name => "pthread_attr_setdetachstate";

   -- Destroy thread attribute *ATTR.
   function pthread_attr_destroy
     (uu_attr : access pthread_attr_t) return Integer  -- /usr/include/pthread.h:266
   with Import,
        Convention    => C,
        External_Name => "pthread_attr_destroy";

   -- Thread identifiers.  The structure of the attribute type is not exposed on purpose.
   type pthread_t is new Unsigned_64;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:27

   -- Once-only execution
   type pthread_once_t is new Integer;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:53

   -- Functions for handling initialization.
   -- Create a new thread, starting with execution of START-ROUTINE
   --   getting passed ARG.  Creation attributed come from ATTR.  The new
   --   handle is stored in *NEWTHREAD.
   function pthread_create
     (uu_newthread     : access pthread_t;
      uu_attr          : access constant pthread_attr_t;
      uu_start_routine : access function (arg : System.Address) return System.Address;
      uu_arg           : in System.Address) return Integer  -- /usr/include/pthread.h:198
   with Import,
        Convention    => C,
        External_Name => "pthread_create";

   -- Make calling thread wait for termination of the thread TH.  The
   --   exit status of the thread is stored in *THREAD_RETURN, if THREAD_RETURN
   --   is not NULL.
   function pthread_join
     (uu_th            : in pthread_t;
      uu_thread_return : in System.Address) return Integer  -- /usr/include/pthread.h:215
   with Import,
        Convention    => C,
        External_Name => "pthread_join";

   -- Guarantee that the initialization function INIT_ROUTINE will be called
   --   only once, even if pthread_once is executed several times with the
   --   same ONCE_CONTROL argument. ONCE_CONTROL must point to a static or
   --   extern variable initialized to PTHREAD_ONCE_INIT.
   function pthread_once
     (uu_once_control : access pthread_once_t;
      uu_init_routine : access procedure) return Integer  -- /usr/include/pthread.h:470
   with Import,
        Convention    => C,
        External_Name => "pthread_once";

   -- Indicate that the thread TH is never to be joined with PTHREAD_JOIN.
   --   The resources of TH will therefore be freed immediately when it
   --   terminates, instead of waiting for another thread to perform PTHREAD_JOIN
   --   on it.
   function pthread_detach
     (uu_th : in pthread_t) return Integer  -- /usr/include/pthread.h:247
   with Import,
        Convention    => C,
        External_Name => "pthread_detach";

   -- Cancel THREAD immediately or at the next possibility.
   function pthread_cancel
     (uu_th : in pthread_t) return Integer  -- /usr/include/pthread.h:489
   with Import,
        Convention    => C,
        External_Name => "pthread_cancel";

   -- Yield the processor to another thread or process.
   --   This function is similar to the POSIX `sched_yield' function but
   --   might be differently implemented in the case of a m-on-n thread
   --   implementation.
   function pthread_yield return Integer  -- /usr/include/pthread.h:445
   with Import,
        Convention    => C,
        External_Name => "pthread_yield";

   -- Obtain the identifier of the current thread.
   function pthread_self return pthread_t  -- /usr/include/pthread.h:251
   with Import,
        Convention    => C,
        External_Name => "pthread_self";

   -- Terminate calling thread.
   procedure pthread_exit
     (uu_retval : in System.Address)  -- /usr/include/pthread.h:207
   with Import,
        Convention    => C,
        External_Name => "pthread_exit";

end pthread;
