-- Ada-program for MT19937-64 x86_64. Coded by Wojciech Lawren.

-- Copyright (C) 2020, Wojciech Lawren, All rights reserved.

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
-- INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
-- SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
-- SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
-- WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
-- USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

-- References:
-- T. Nishimura, ``Tables of 64-bit Mersenne Twisters''
--   ACM Transactions on Modeling and
--   Computer Simulation 10. (2000) 348--357.
-- M. Matsumoto and T. Nishimura,
--   ``Mersenne Twister: a 623-dimensionally equidistributed
--     uniform pseudorandom number generator''
--   ACM Transactions on Modeling and
--   Computer Simulation 8. (Jan. 1998) 3--30.
pragma Ada_2020;

with System.Machine_Code; use System.Machine_Code;

package body MTavx is

   NL : constant String := ASCII.LF & ASCII.HT;

   function genrand64 (x : in Unsigned_64) return Unsigned_64 is
      r : Unsigned_64 := 0;
   begin
      Asm (Template => "vzeroall"                                     & NL &
                       "vpinsrq $0, mtavx__h1(%%rip), %%xmm2, %%xmm2" & NL &
                       "vpinsrq $0, mtavx__h2(%%rip), %%xmm0, %%xmm0" & NL &
                       "vpinsrq $0, mtavx__h3(%%rip), %%xmm4, %%xmm4" & NL &
                       "vpinsrq $0, %1, %%xmm3, %%xmm3"               & NL &
                       "vpsrlq $29, %%xmm3, %%xmm1"                   & NL &
                       "vpand %%xmm2, %%xmm1, %%xmm2"                 & NL &
                       "vpxor %%xmm3, %%xmm2, %%xmm3"                 & NL &
                       "vpsllq $17, %%xmm3, %%xmm1"                   & NL &
                       "vpand %%xmm0, %%xmm1, %%xmm0"                 & NL &
                       "vpxor %%xmm3, %%xmm0, %%xmm2"                 & NL &
                       "vpsllq $37, %%xmm2, %%xmm1"                   & NL &
                       "vpand %%xmm4, %%xmm1, %%xmm0"                 & NL &
                       "vpxor %%xmm2, %%xmm0, %%xmm0"                 & NL &
                       "vpsrlq $43, %%xmm0, %%xmm1"                   & NL &
                       "vpxor %%xmm0, %%xmm1, %%xmm0"                 & NL &
                       "vpextrq $0, %%xmm0, %0",
           Outputs  => (Unsigned_64'Asm_Output ("=r", r)),
           Inputs   => (Unsigned_64'Asm_Input ("r", x)));
      return r;
   end genrand64;

end MTavx;
