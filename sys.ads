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
with sys_t;      use sys_t;

package sys with
   No_Elaboration_Code_All,
   Pure
is

   procedure write (x : in String) with No_Inline;

   procedure sched_yield with No_Inline;

   function sched_setaffinity
     (pid        : in pid_t;  -- gettid for threaded programs.
      cpusetsize : in Unsigned_64 := (cpu_set_t'Size / 8);
      cpuset     : access constant cpu_set_t) return Integer with No_Inline;

   procedure pause with No_Inline;

   function futex (f : access Atomic_32; op : in Integer; val : in Unsigned_32) return Integer with No_Inline;

   procedure exit0 (s : in Integer := 0) with No_Inline;

   function getpid return pid_t with No_Inline;

   function gettid return pid_t with No_Inline;

   function tgkill (tgid : in pid_t; tid : in pid_t; sig : in Integer) return Integer with No_Inline;

end sys;
