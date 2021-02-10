-- Ada interface for RNG (Cryptographic Co-Processor). Coded by Wojciech Lawren.

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

   LP : constant := 10;
   NL : constant String := ASCII.LF & ASCII.HT;

   RAND : constant String := "mov %1, %%ecx" & NL &
                             "1:"            & NL &
                                "rdrand %0"  & NL &
                                "jc 2f"      & NL &
                                "loop 1b"    & NL &
                                "xor %0, %0" & NL &
                             "2:";
   SEED : constant String := "mov %1, %%ecx" & NL &
                             "1:"            & NL &
                                "rdseed %0"  & NL &
                                "jc 2f"      & NL &
                                "loop 1b"    & NL &
                                "xor %0, %0" & NL &
                             "2:";

   function rand64 return Unsigned_64 is
      r : Unsigned_64;
   begin
      Asm (Template => RAND,
           Outputs  => (Unsigned_64'Asm_Output ("=r", r)),
           Inputs   => (Unsigned_32'Asm_Input ("n", LP)),
           Volatile => True);
      return r;
   end rand64;

   function rand32 return Unsigned_32 is
      r : Unsigned_32;
   begin
      Asm (Template => RAND,
           Outputs  => (Unsigned_32'Asm_Output ("=r", r)),
           Inputs   => (Unsigned_32'Asm_Input ("n", LP)),
           Volatile => True);
      return r;
   end rand32;

   function rand16 return Unsigned_16 is
      r : Unsigned_16;
   begin
      Asm (Template => RAND,
           Outputs  => (Unsigned_16'Asm_Output ("=r", r)),
           Inputs   => (Unsigned_32'Asm_Input ("n", LP)),
           Volatile => True);
      return r;
   end rand16;

   function seed64 return Unsigned_64 is
      r : Unsigned_64;
   begin
      Asm (Template => SEED,
           Outputs  => (Unsigned_64'Asm_Output ("=r", r)),
           Inputs   => (Unsigned_32'Asm_Input ("n", LP)),
           Volatile => True);
      return r;
   end seed64;

   function seed32 return Unsigned_32 is
      r : Unsigned_32;
   begin
      Asm (Template => SEED,
           Outputs  => (Unsigned_32'Asm_Output ("=r", r)),
           Inputs   => (Unsigned_32'Asm_Input ("n", LP)),
           Volatile => True);
      return r;
   end seed32;

   function seed16 return Unsigned_16 is
      r : Unsigned_16;
   begin
      Asm (Template => SEED,
           Outputs  => (Unsigned_16'Asm_Output ("=r", r)),
           Inputs   => (Unsigned_32'Asm_Input ("n", LP)),
           Volatile => True);
      return r;
   end seed16;

end rdrand;
