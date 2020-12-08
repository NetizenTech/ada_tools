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

with Atomic;     use Atomic;
with Interfaces; use Interfaces;

package sys with
   No_Elaboration_Code_All,
   Pure
is
   FUTEX_WAIT : constant := 0;
   FUTEX_WAKE : constant := 1;

   SIGUSR1 : constant := 10;
   SIGUSR2 : constant := 12;

   type pid_t is new Integer;

   type tid_t is array (Unsigned_8) of aliased pid_t with
      Default_Component_Value => pid_t'Last;

   type lock_t is record
      f1 : aliased Atomic_32 := 1;
      f2 : aliased Atomic_64 := 1;
      q1 : aliased Atomic_64 := 1;
      q2 : aliased Atomic_64 := 1;
      f3 : aliased Atomic_64 := 1;
      q3 : aliased Atomic_64 := 1;
      q4 : aliased Atomic_64 := 1;
      n1 : aliased tid_t;
   end record;

   procedure write (x : in String) with No_Inline;

   procedure exit0 (s : in Integer := 0) with No_Inline;

   function futex (f : access Atomic_32; op : in Integer; val : in Unsigned_32) return Integer with No_Inline;

   function futex_lock (f : access lock_t) return Integer with No_Inline;

   function futex_unlock (f : access lock_t) return Integer with No_Inline;

   procedure fast_lock (f : access lock_t) with No_Inline;

   function fast_unlock (f : access lock_t) return Integer with No_Inline;

   procedure sig_lock (f : access lock_t) with No_Inline;

   function sig_unlock (f : access lock_t) return Integer with No_Inline;

   procedure sched_yield with No_Inline;

   procedure pause with No_Inline;

   function getpid return pid_t with No_Inline;

   function gettid return pid_t with No_Inline;

   function tgkill (tgid : in pid_t; tid : in pid_t; sig : in Integer) return Integer with No_Inline;

end sys;
