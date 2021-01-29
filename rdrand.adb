-- Ada-program for random 64-bit hardware-generated value x86_64. Coded by Wojciech Lawren.

-- Copyright (C) 2020, Wojciech Lawren, All rights reserved.

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
-- INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
-- SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
-- SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
-- WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
-- USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

-- References:
-- https://www.amd.com/system/files/TechDocs/amd-random-number-generator.pdf
-- https://software.intel.com/content/www/us/en/develop/articles/intel-digital-random-number-generator-drng-software-implementation-guide.html
pragma Ada_2020;

with System.Machine_Code; use System.Machine_Code;

package body rdrand is

   NL : constant String := ASCII.LF & ASCII.HT;

   -- hardware-generated random value
   function rand64 return Unsigned_64 is
      r : Unsigned_64 := 0;
   begin
      Asm (Template => "rdrand %0",
            Outputs  => (Unsigned_64'Asm_Output ("=r", r)),
            Volatile => True);
      return r;
   end rand64;

   -- hardware-generated random value
   function sec_rand64 return Unsigned_64 is
      r : Unsigned_64;
   begin
      Asm (Template => "movl $10, %%ecx"      & NL &
                       "1:"                   & NL &
                           "rdrand %0"        & NL &
                           "jc 2f"            & NL &
                           "loop 1b"          & NL &
                           "cmovnc %%rcx, %0" & NL &
                       "2:",
           Outputs  => (Unsigned_64'Asm_Output ("=r", r)),
           Volatile => True);
      return r;
   end sec_rand64;

end rdrand;
