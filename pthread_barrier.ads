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

package pthread_barrier with
   No_Elaboration_Code_All,
   Pure
is
   -- POSIX barriers ATTR data type.
   type pthread_barrierattr_t_array1026 is array (0 .. 3) of aliased Unsigned_8;
   type pthread_barrierattr_t (discr : Unsigned_32 := 0) is record
      case discr is
         when 0 =>
            uu_size  : aliased pthread_barrierattr_t_array1026;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:116
         when others =>
            uu_align : aliased Integer;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:117
      end case;
   end record
   with Unchecked_Union => True;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:118

   -- Initialize barrier attribute ATTR.
   function pthread_barrierattr_init
     (uu_attr : access pthread_barrierattr_t) return Integer  -- /usr/include/pthread.h:1095
   with Import,
        Convention    => C,
        External_Name => "pthread_barrierattr_init";

   -- Destroy previously dynamically initialized barrier attribute ATTR.
   function pthread_barrierattr_destroy
     (uu_attr : access pthread_barrierattr_t) return Integer  -- /usr/include/pthread.h:1099
   with Import,
        Convention    => C,
        External_Name => "pthread_barrierattr_destroy";

   -- POSIX barriers data type.  The structure of the type is
   --   deliberately not exposed.
   type pthread_barrier_t_array1054 is array (0 .. 31) of aliased Unsigned_8;
   type pthread_barrier_t (discr : Unsigned_32 := 0) is record
      case discr is
         when 0 =>
            uu_size  : aliased pthread_barrier_t_array1054;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:110
         when others =>
            uu_align : aliased Long_integer;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:111
      end case;
   end record
   with Unchecked_Union => True;  -- /usr/include/x86_64-linux-gnu/bits/pthreadtypes.h:112

   -- Functions to handle barriers.
   -- Initialize BARRIER with the attributes in ATTR.  The barrier is
   --   opened when COUNT waiters arrived.
   function pthread_barrier_init
     (uu_barrier : access pthread_barrier_t;
      uu_attr    : access constant pthread_barrierattr_t;
      uu_count   : in Unsigned_32) return Integer  -- /usr/include/pthread.h:1080
   with Import,
        Convention    => C,
        External_Name => "pthread_barrier_init";

   -- Wait on barrier BARRIER.
   function pthread_barrier_wait
     (uu_barrier : access pthread_barrier_t) return Integer  -- /usr/include/pthread.h:1090
   with Import,
        Convention    => C,
        External_Name => "pthread_barrier_wait";

   -- Destroy a previously dynamically initialized barrier BARRIER.
   function pthread_barrier_destroy
     (uu_barrier : access pthread_barrier_t) return Integer  -- /usr/include/pthread.h:1086
   with Import,
        Convention    => C,
        External_Name => "pthread_barrier_destroy";

end pthread_barrier;
