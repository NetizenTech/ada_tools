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
   PTHREAD_MUTEX_NORMAL     : constant := 0;
   PTHREAD_MUTEX_RECURSIVE  : constant := 1;
   PTHREAD_MUTEX_ERRORCHECK : constant := 2;
   PTHREAD_MUTEX_DEFAULT    : constant := PTHREAD_MUTEX_RECURSIVE;

   -- Data structures for mutex handling.
   -- Common definition of pthread_mutex_t.
   type pthread_internal_list;
   type pthread_internal_list is record
      prev : access pthread_internal_list := null;  -- /usr/include/x86_64-linux-gnu/bits/thread-shared-types.h:51
      next : access pthread_internal_list := null;  -- /usr/include/x86_64-linux-gnu/bits/thread-shared-types.h:52
   end record;  -- /usr/include/x86_64-linux-gnu/bits/thread-shared-types.h:49

   subtype pthread_list_t is pthread_internal_list;  -- /usr/include/x86_64-linux-gnu/bits/thread-shared-types.h:53

   type pthread_mutex_s is record
      lock    : aliased Integer       := 0;  -- /usr/include/x86_64-linux-gnu/bits/struct_mutex.h:24
      count   : aliased Unsigned_32   := 0;  -- /usr/include/x86_64-linux-gnu/bits/struct_mutex.h:25
      owner   : aliased Integer       := 0;  -- /usr/include/x86_64-linux-gnu/bits/struct_mutex.h:26
      nusers  : aliased Unsigned_32   := 0;  -- /usr/include/x86_64-linux-gnu/bits/struct_mutex.h:28
      kind    : aliased Integer       := PTHREAD_MUTEX_DEFAULT;  -- /usr/include/x86_64-linux-gnu/bits/struct_mutex.h:32
      spins   : aliased Short_Integer := 0;  -- /usr/include/x86_64-linux-gnu/bits/struct_mutex.h:34
      elision : aliased Short_Integer := 0;  -- /usr/include/x86_64-linux-gnu/bits/struct_mutex.h:35
      list    : aliased pthread_list_t;  -- /usr/include/x86_64-linux-gnu/bits/struct_mutex.h:36
   end record;  -- /usr/include/x86_64-linux-gnu/bits/struct_mutex.h:22

   type pthread_mutex_t_array1038 is array (0 .. 39) of Unsigned_8 with
      Default_Component_Value => 0;
   type pthread_mutex_t (discr : Unsigned_32 := 0) is record
      case discr is
         when 0 =>
            data  : aliased pthread_mutex_s;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:69
         when 1 =>
            size  : aliased pthread_mutex_t_array1038;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:70
         when others =>
            align : aliased Long_Integer;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:71
      end case;
   end record
   with Unchecked_Union;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:72

   -- Lock a mutex.
   function pthread_mutex_lock
     (mutex : access pthread_mutex_t) return Integer  -- /usr/include/pthread.h:738
   with Import,
        Convention    => C,
        External_Name => "pthread_mutex_lock";

   -- Unlock a mutex.
   function pthread_mutex_unlock
     (mutex : access pthread_mutex_t) return Integer  -- /usr/include/pthread.h:756
   with Import,
        Convention    => C,
        External_Name => "pthread_mutex_unlock";

end pthread_mutex;
