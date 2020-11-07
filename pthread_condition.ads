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

with Interfaces; use Interfaces;
with pthread_mutex;

package pthread_condition with
   No_Elaboration_Code_All,
   Pure
is
   -- Data structure for condition variable handling.  The structure of
   --   the attribute type is not exposed on purpose.
   type pthread_condattr_t_array1026 is array (0 .. 3) of aliased Unsigned_8;
   type pthread_condattr_t (discr : Unsigned_32 := 0) is record
      case discr is
         when 0 =>
            uu_size  : aliased pthread_condattr_t_array1026;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:43
         when others =>
            uu_align : aliased Integer;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:44
      end case;
   end record
   with Unchecked_Union;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:45

   -- Functions for handling condition variable attributes.
   -- Initialize condition variable attribute ATTR.
   function pthread_condattr_init
     (uu_attr : access pthread_condattr_t) return Integer  -- /usr/include/pthread.h:1020
   with Import,
        Convention    => C,
        External_Name => "pthread_condattr_init";

   -- Destroy condition variable attribute ATTR.
   function pthread_condattr_destroy
     (uu_attr : access pthread_condattr_t) return Integer  -- /usr/include/pthread.h:1024
   with Import,
        Convention    => C,
        External_Name => "pthread_condattr_destroy";

   -- Common definition of pthread_cond_t.
   type anon1017_struct1019 is record
      uu_low  : aliased Unsigned_32;  -- /usr/include/x86_64-linux-gnu/bits/thread-shared-types.h:99
      uu_high : aliased Unsigned_32;  -- /usr/include/x86_64-linux-gnu/bits/thread-shared-types.h:100
   end record;

   type anon1017_union1020 (discr : Unsigned_32 := 0) is record
      case discr is
         when 0 =>
            uu_g1_start   : aliased Unsigned_64;  -- /usr/include/x86_64-linux-gnu/bits/thread-shared-types.h:105
         when others =>
            uu_g1_start32 : aliased anon1017_struct1019;  -- /usr/include/x86_64-linux-gnu/bits/thread-shared-types.h:110
      end case;
   end record
   with Unchecked_Union;

   type anon1017_array1022 is array (0 .. 1) of aliased Unsigned_32;
   type uu_pthread_cond_s is record
      anon2273        : aliased anon1017_union1020;  -- /usr/include/x86_64-linux-gnu/bits/thread-shared-types.h:102
      anon2280        : aliased anon1017_union1020;  -- /usr/include/x86_64-linux-gnu/bits/thread-shared-types.h:111
      uu_g_refs       : aliased anon1017_array1022;  -- /usr/include/x86_64-linux-gnu/bits/thread-shared-types.h:112
      uu_g_size       : aliased anon1017_array1022;  -- /usr/include/x86_64-linux-gnu/bits/thread-shared-types.h:113
      uu_g1_orig_size : aliased Unsigned_32;  -- /usr/include/x86_64-linux-gnu/bits/thread-shared-types.h:114
      uu_wrefs        : aliased Unsigned_32;  -- /usr/include/x86_64-linux-gnu/bits/thread-shared-types.h:115
      uu_g_signals    : aliased anon1017_array1022;  -- /usr/include/x86_64-linux-gnu/bits/thread-shared-types.h:116
   end record;  -- /usr/include/x86_64-linux-gnu/bits/thread-shared-types.h:92

   type pthread_cond_t_array1042 is array (0 .. 47) of aliased Unsigned_8;
   type pthread_cond_t (discr : Unsigned_32 := 0) is record
      case discr is
         when 0 =>
            uu_data  : aliased uu_pthread_cond_s;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:77
         when 1 =>
            uu_size  : aliased pthread_cond_t_array1042;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:78
         when others =>
            uu_align : aliased Long_Long_Integer;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:79
      end case;
   end record
   with Unchecked_Union;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:80

   -- Functions for handling conditional variables.
   -- Initialize condition variable COND using attributes ATTR, or use
   --   the default values if later is NULL.
   function pthread_cond_init
     (uu_cond      : access pthread_cond_t;
      uu_cond_attr : access constant pthread_condattr_t) return Integer  -- /usr/include/pthread.h:965
   with Import,
        Convention    => C,
        External_Name => "pthread_cond_init";

   -- Wake up one thread waiting for condition variable COND.
   function pthread_cond_signal
     (uu_cond : access pthread_cond_t) return Integer  -- /usr/include/pthread.h:974
   with Import,
        Convention    => C,
        External_Name => "pthread_cond_signal";

   -- Wake up all threads waiting for condition variables COND.
   function pthread_cond_broadcast
     (uu_cond : access pthread_cond_t) return Integer  -- /usr/include/pthread.h:978
   with Import,
        Convention    => C,
        External_Name => "pthread_cond_broadcast";

   -- Wait for condition variable COND to be signaled or broadcast.
   --   MUTEX is assumed to be locked before.
   function pthread_cond_wait
     (uu_cond  : access pthread_cond_t;
      uu_mutex : access pthread_mutex.pthread_mutex_t) return Integer  -- /usr/include/pthread.h:986
   with Import,
        Convention    => C,
        External_Name => "pthread_cond_wait";

   -- Wait for condition variable COND to be signaled or broadcast until
   --   ABSTIME.  MUTEX is assumed to be locked before.  ABSTIME is an
   --   absolute time specification; zero is the beginning of the epoch
   --   (00:00:00 GMT, January 1, 1970).
   function pthread_cond_timedwait
     (uu_cond    : access pthread_cond_t;
      uu_mutex   : access pthread_mutex.pthread_mutex_t;
      uu_abstime : access constant pthread_mutex.timespec) return Integer  -- /usr/include/pthread.h:997
   with Import,
        Convention    => C,
        External_Name => "pthread_cond_timedwait";

   -- Destroy condition variable COND.
   function pthread_cond_destroy
     (uu_cond : access pthread_cond_t) return Integer  -- /usr/include/pthread.h:970
   with Import,
        Convention    => C,
        External_Name => "pthread_cond_destroy";

end pthread_condition;
