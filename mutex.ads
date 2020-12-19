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

with Atomic;     use Atomic;
with Interfaces; use Interfaces;
with sys_t;      use sys_t;

package mutex with
   No_Elaboration_Code_All,
   Pure
is
   FUTEX_WAIT : constant := 0;
   FUTEX_WAKE : constant := 1;

   SIG_WAKE : constant := SIGRTMAX;

   type tid_t is array (Unsigned_8) of aliased pid_t with
      Default_Component_Value => pid_t'Last;

   type queue_t is limited record
      fq : aliased ptr16b := (1, 1);
      q2 : aliased Atomic_64 := 1;
   end record;

   type lock_t is limited record
      f1 : aliased queue_t;
      f2 : aliased queue_t;
      f3 : aliased Atomic_32 := 1;
      f4 : aliased Atomic_32 := 1;
      n2 : aliased tid_t;
   end record;

   function futex_lock (f : access lock_t) return Integer with No_Inline;

   function futex_unlock (f : access lock_t) return Integer with No_Inline;

   -- short random lock
   procedure fast_lock (f : access lock_t) with No_Inline;

   function fast_unlock (f : access lock_t) return Integer with No_Inline;

   -- short enqueued lock
   procedure queue_lock (f : access lock_t) with No_Inline;

   function queue_unlock (f : access lock_t) return Integer with No_Inline;

   function reset_queue (f : access lock_t) return Integer with No_Inline;

   -- long enqueued lock
   procedure sig_lock (f : access lock_t) with No_Inline;

   function sig_unlock (f : access lock_t) return Integer with No_Inline;

end mutex;
