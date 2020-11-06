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

package pthread_mutex with
   No_Elaboration_Code_All,
   Pure
is
   -- Data structures for mutex handling.  The structure of the attribute
   --   type is not exposed on purpose.
   type pthread_mutexattr_t_array1026 is array (0 .. 3) of aliased Unsigned_8;
   type pthread_mutexattr_t (discr : Unsigned_32 := 0) is record
      case discr is
         when 0 =>
            uu_size  : aliased pthread_mutexattr_t_array1026;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:34
         when others =>
            uu_align : aliased Integer;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:35
      end case;
   end record
   with Unchecked_Union;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:36

   -- Functions for handling mutex attributes.
   -- Initialize mutex attribute object ATTR with default attributes
   --   (kind is PTHREAD_MUTEX_TIMED_NP).
   function pthread_mutexattr_init
     (uu_attr : access pthread_mutexattr_t) return Integer  -- /usr/include/pthread.h:789
   with Import,
        Convention    => C,
        External_Name => "pthread_mutexattr_init";

   -- Return in *KIND the mutex kind attribute in *ATTR.
   function pthread_mutexattr_gettype
     (uu_attr : access constant pthread_mutexattr_t;
      uu_kind : access Integer) return Integer  -- /usr/include/pthread.h:809
   with Import,
        Convention    => C,
        External_Name => "pthread_mutexattr_gettype";

  -- Set the mutex kind attribute in *ATTR to KIND (either PTHREAD_MUTEX_NORMAL,
  --   PTHREAD_MUTEX_RECURSIVE, PTHREAD_MUTEX_ERRORCHECK, or
  --   PTHREAD_MUTEX_DEFAULT).
   function pthread_mutexattr_settype
     (uu_attr : access pthread_mutexattr_t;
     uu_kind  : Integer) return Integer  -- /usr/include/pthread.h:816
   with Import,
        Convention    => C,
        External_Name => "pthread_mutexattr_settype";

   -- Destroy mutex attribute object ATTR.
   function pthread_mutexattr_destroy
     (uu_attr : access pthread_mutexattr_t) return Integer  -- /usr/include/pthread.h:793
   with Import,
        Convention    => C,
        External_Name => "pthread_mutexattr_destroy";

   -- Data structures for mutex handling.
   -- Common definition of pthread_mutex_t.
   type uu_pthread_internal_list;
   type uu_pthread_internal_list is record
      uu_prev : access uu_pthread_internal_list;  -- /usr/include/x86_64-linux-gnu/bits/thread-shared-types.h:51
      uu_next : access uu_pthread_internal_list;  -- /usr/include/x86_64-linux-gnu/bits/thread-shared-types.h:52
   end record;  -- /usr/include/x86_64-linux-gnu/bits/thread-shared-types.h:49

   subtype uu_pthread_list_t is uu_pthread_internal_list;  -- /usr/include/x86_64-linux-gnu/bits/thread-shared-types.h:53

   type uu_pthread_mutex_s is record
      uu_lock    : aliased Integer;  -- /usr/include/x86_64-linux-gnu/bits/struct_mutex.h:24
      uu_count   : aliased Unsigned_32;  -- /usr/include/x86_64-linux-gnu/bits/struct_mutex.h:25
      uu_owner   : aliased Integer;  -- /usr/include/x86_64-linux-gnu/bits/struct_mutex.h:26
      uu_nusers  : aliased Unsigned_32;  -- /usr/include/x86_64-linux-gnu/bits/struct_mutex.h:28
      uu_kind    : aliased Integer;  -- /usr/include/x86_64-linux-gnu/bits/struct_mutex.h:32
      uu_spins   : aliased Short_Integer;  -- /usr/include/x86_64-linux-gnu/bits/struct_mutex.h:34
      uu_elision : aliased Short_Integer;  -- /usr/include/x86_64-linux-gnu/bits/struct_mutex.h:35
      uu_list    : aliased uu_pthread_list_t;  -- /usr/include/x86_64-linux-gnu/bits/struct_mutex.h:36
   end record;  -- /usr/include/x86_64-linux-gnu/bits/struct_mutex.h:22

   type pthread_mutex_t_array1038 is array (0 .. 39) of Unsigned_8;
   type pthread_mutex_t is record
      uu_data  : aliased uu_pthread_mutex_s;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:69
      uu_size  : aliased pthread_mutex_t_array1038;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:70
      uu_align : aliased Unsigned_64;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:71
   end record;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:72

   type timespec is record
      tv_sec  : aliased Unsigned_64;  -- /usr/include/x86_64-linux-gnu/bits/types/struct_timespec.h:12
      tv_nsec : aliased Unsigned_64;  -- /usr/include/x86_64-linux-gnu/bits/types/struct_timespec.h:16
   end record;  -- /usr/include/x86_64-linux-gnu/bits/types/struct_timespec.h:10

   -- Mutex handling.
   -- Initialize a mutex.
   function pthread_mutex_init
     (uu_mutex     : access pthread_mutex_t;
      uu_mutexattr : access constant pthread_mutexattr_t) return Integer  -- /usr/include/pthread.h:725
   with Import,
        Convention    => C,
        External_Name => "pthread_mutex_init";

   -- Try locking a mutex.
   function pthread_mutex_trylock
     (uu_mutex : access pthread_mutex_t) return Integer  -- /usr/include/pthread.h:734
   with Import,
        Convention    => C,
        External_Name => "pthread_mutex_trylock";

   -- Lock a mutex.
   function pthread_mutex_lock
     (uu_mutex : access pthread_mutex_t) return Integer  -- /usr/include/pthread.h:738
   with Import,
        Convention    => C,
        External_Name => "pthread_mutex_lock";

   -- Wait until lock becomes available, or specified time passes.
   function pthread_mutex_timedlock
     (uu_mutex   : access pthread_mutex_t;
      uu_abstime : access constant timespec) return Integer  -- /usr/include/pthread.h:743
   with Import,
        Convention    => C,
        External_Name => "pthread_mutex_timedlock";

   -- Unlock a mutex.
   function pthread_mutex_unlock
     (uu_mutex : access pthread_mutex_t) return Integer  -- /usr/include/pthread.h:756
   with Import,
        Convention    => C,
        External_Name => "pthread_mutex_unlock";

   -- Destroy a mutex.
   function pthread_mutex_destroy
     (uu_mutex : access pthread_mutex_t) return Integer  -- /usr/include/pthread.h:730
   with Import,
        Convention    => C,
        External_Name => "pthread_mutex_destroy";

end pthread_mutex;
