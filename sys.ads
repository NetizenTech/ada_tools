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

   type futex_t is record
      f1 : aliased Atomic_32 := 1;
   end record;

   type pid_t is new Integer;

   procedure write (x : in String);

   procedure exit0 (s : in Integer := 0);

   procedure futex (f : access Atomic_32; op : in Integer; val : in Unsigned_32);

   procedure futex_lock (f : access futex_t);

   procedure futex_unlock (f : access futex_t);

   procedure pause;

   function getpid return pid_t;

   function gettid return pid_t;

   procedure tgkill (tgid : in pid_t; tid : in pid_t; sig : in Integer);

end sys;
