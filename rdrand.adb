-- Ada-program for random 64-bit hardware-generated value. Coded by Wojciech Lawren.

-- Copyright (C) 2020, Wojciech Lawren, All rights reserved.

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
-- INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
-- SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
-- SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
-- WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
-- USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
pragma Ada_2020;

with System.Machine_Code; use System.Machine_Code;

package body rdrand is

   NL : constant String := ASCII.LF & ASCII.HT;
   RC : constant := 2;

   -- hardware-generated random value
   function rand64 return Unsigned_64 is
      r : Unsigned_64;
   begin
      Asm (Template => ".rd_start:"         & NL &
                           "rdrand %%rax"      & NL &
                           "jc .rd_end"     & NL &
                           "loop .rd_start" & NL &
                       ".rd_end:",
           Outputs  => (Unsigned_64'Asm_Output ("=a", r)),
           Inputs   => (Unsigned_64'Asm_Input ("c", RC)));
      return r;
   end Rand64;

end rdrand;
