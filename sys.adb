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
      NR_write : constant := 1;
      fd       : constant := 1;
   begin
      Asm (Template => "movl %1, %%edx" & NL &
                       "movl %2, %%edi" & NL &
                       "movl %3, %%eax" & NL &
                       "syscall",
           Inputs   => (System.Address'Asm_Input ("S", x'Address),
                        Integer'Asm_Input ("r", x'Length),
                        Integer'Asm_Input ("n", fd),
                        Integer'Asm_Input ("n", NR_write)),
           Volatile => True);
   end write;

   procedure exit0 (s : in Integer := 0) is
      NR_exit : constant := 60;
   begin
      Asm (Template => "movl %1, %%eax" & NL &
                       "syscall",
           Inputs   => (Integer'Asm_Input ("D", s),
                        Integer'Asm_Input ("n", NR_exit)),
           Volatile => True);
   end exit0;

end sys;
