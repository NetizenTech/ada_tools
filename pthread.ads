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
   subtype pthread_t is Unsigned_64;

   type anon1013_array1015 is array (0 .. 55) of Unsigned_8;
   type pthread_attr_t is record
      uu_size  : aliased anon1013_array1015;
      uu_align : aliased Unsigned_64;
   end record
   with Convention => C_Pass_By_Copy;

   -- Thread attribute handling.
   -- Initialize thread attribute *ATTR with default attributes
   --   (detachstate is PTHREAD_JOINABLE, scheduling policy is SCHED_OTHER,
   --    no user-provided stack).
   function pthread_attr_init
     (uu_attr : access pthread_attr_t) return Integer  -- /usr/include/pthread.h:263
   with Import,
        Convention    => C,
        External_Name => "pthread_attr_init";

   function pthread_attr_getstacksize
     (uu_attr      : access constant pthread_attr_t;
      uu_stacksize : access Unsigned_64) return Integer  -- /usr/include/pthread.h:344
   with Import,
        Convention    => C,
        External_Name => "pthread_attr_getstacksize";

   function pthread_attr_setstacksize
     (uu_attr      : access pthread_attr_t;
      uu_stacksize : in Unsigned_64) return Integer  -- /usr/include/pthread.h:351
   with Import,
        Convention    => C,
        External_Name => "pthread_attr_setstacksize";

   function pthread_attr_destroy
     (uu_attr : access pthread_attr_t) return Integer  -- /usr/include/pthread.h:266
   with Import,
        Convention    => C,
        External_Name => "pthread_attr_destroy";

   function pthread_create
     (uu_newthread     : access pthread_t;
      uu_attr          : access constant pthread_attr_t;
      uu_start_routine : access function (arg : System.Address) return System.Address;
      uu_arg           : in System.Address) return Integer  -- /usr/include/pthread.h:198
   with Import,
        Convention    => C,
        External_Name => "pthread_create";

   function pthread_join
     (uu_th            : in pthread_t;
      uu_thread_return : in System.Address) return Integer  -- /usr/include/pthread.h:215
   with Import,
        Convention    => C,
        External_Name => "pthread_join";

   function pthread_self return pthread_t  -- /usr/include/pthread.h:251
   with Import,
        Convention    => C,
        External_Name => "pthread_self";

   procedure pthread_exit
     (uu_retval : in System.Address)  -- /usr/include/pthread.h:207
   with Import,
        Convention    => C,
        External_Name => "pthread_exit";

end pthread;
