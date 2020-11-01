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

with System;
with System.Machine_Code; use System.Machine_Code;

package body sys is

   NL : constant String := ASCII.LF & ASCII.HT;

   procedure write (x : in String) is
   begin
      Asm (Template => "movq %1, %%rdx"                   & NL &
                       "movq $1, %%rdi"                   & NL &
                       "movq sys__nr_write(%%rip), %%rax" & NL &
                       "syscall",
           Inputs   => (System.Address'Asm_Input ("S", x'Address),
                        Unsigned_64'Asm_Input ("r", Unsigned_64 (x'Length))),
           Volatile => True);
   end write;

   procedure nanosleep (t : access constant timespec) is
   begin
      Asm (Template => "xorq %%rsi, %%rsi"                    & NL &
                       "movq sys__nr_nanosleep(%%rip), %%rax" & NL &
                       "syscall",
           Inputs   => (System.Address'Asm_Input ("D", t.all'Address)),
           Volatile => True);
   end nanosleep;

   procedure exit0 (s : in Integer := 0) is
   begin
      Asm (Template => "movq sys__nr_exit(%%rip), %%rax" & NL &
                       "syscall",
           Inputs   => (Integer'Asm_Input ("D", s)),
           Volatile => True);
   end exit0;

end sys;
