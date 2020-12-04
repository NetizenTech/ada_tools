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

with pthread;
with System;
with Interfaces; use Interfaces;

package pthread_signal with
   No_Elaboration_Code_All,
   Pure
is
   SIG_SETSIZE : constant := 1_024;

   type sig_mask is new Unsigned_64;

   -- A set of signals to be blocked, unblocked, or waited for.
   type sigset_t_array868 is array (0 .. ((SIG_SETSIZE / sig_mask'Size) - 1)) of aliased sig_mask with
      Default_Component_Value => 0;
   type sigset_t is record
      val : aliased sigset_t_array868;  -- /usr/include/x86_64-linux-gnu/bits/types/__sigset_t.h:7
   end record;  -- /usr/include/x86_64-linux-gnu/bits/types/__sigset_t.h:8

   -- Type for data associated with a signal.
   type sigval_t (discr : Unsigned_32 := 0) is record
      case discr is
         when 0 =>
            sival_int : aliased Integer;  -- /usr/include/x86_64-linux-gnu/bits/types/__sigval_t.h:26
         when others =>
            sival_ptr : System.Address;  -- /usr/include/x86_64-linux-gnu/bits/types/__sigval_t.h:27
      end case;
   end record
   with Unchecked_Union;  -- /usr/include/x86_64-linux-gnu/bits/types/__sigval_t.h:24

   -- Signal handling function for threaded programs.

   -- Modify the signal mask for the calling thread.  The arguments have
   --   the same meaning as for sigprocmask(2).
   function pthread_sigmask
     (how     : in Integer;
      newmask : access constant sigset_t;
      oldmask : access sigset_t := null) return Integer  -- /usr/include/x86_64-linux-gnu/bits/sigthread.h:31
   with Import;

   -- Send signal SIGNO to the given thread.
   function pthread_kill
     (threadid : in pthread.pthread_t;
      signo    : in Integer) return Integer  -- /usr/include/x86_64-linux-gnu/bits/sigthread.h:36
   with Import;

   -- Queue signal and data to a thread.
   function pthread_sigqueue
     (threadid : in pthread.pthread_t;
      signo    : in Integer;
      value    : in sigval_t) return Integer  -- /usr/include/x86_64-linux-gnu/bits/sigthread.h:40
   with Import;

   -- light-weight processes in the same thread group must share signals
   SIG_ERR : constant := 16#FFFF_FFFF_FFFF_FFFF#;

   -- Set the handler for the signal SIG to HANDLER, returning the old
   --   handler, or SIG_ERR on error.
   function signal
     (sig     : in Integer;
      handler : in System.Address) return System.Address  -- /usr/include/signal.h:88
   with Import;

   -- Suspend the process until a signal arrives.
   --   This always returns -1 and sets `errno' to EINTR.
   procedure pause  -- /usr/include/unistd.h:469
   with Import;

end pthread_signal;
