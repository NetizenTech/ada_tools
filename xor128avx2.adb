-- Ada-program for xor128 (64-bit). Coded by Wojciech Lawren.

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

package body xor128avx2 is

   NL : constant String := ASCII.LF & ASCII.HT;

   -- Algorithm "xor128" from p. 5 Marsaglia, "Xorshift RNGs"
   function xrand64 (x : access xs256s) return Unsigned_64 is
      r : Unsigned_64;
   begin
      Asm (Template => "vzeroall"                               & NL &
                       "prefetcht0 (%1)"                        & NL &
                       "vmovdqu (%1), %%ymm0"                   & NL &
                       "vpextrq $0, %%xmm0, %%rax"              & NL &
                       "vpinsrq $0, %%rax, %%xmm2, %%xmm2"      & NL &
                       "vpermq $147, %%ymm0, %%ymm1"            & NL &
                       "vpextrq $0, %%xmm1, %%rax"              & NL &
                       "vpinsrq $0, %%rax, %%xmm3, %%xmm3"      & NL &
                       "vpsllq $11, %%xmm3, %%xmm0"             & NL &
                       "vpxor %%xmm3, %%xmm0, %%xmm3"           & NL &
                       "vpsrlq $8, %%xmm3, %%xmm0"              & NL &
                       "vpxor %%xmm3, %%xmm0, %%xmm3"           & NL &
                       "vpsrlq $19, %%xmm2, %%xmm0"             & NL &
                       "vpxor %%xmm2, %%xmm0, %%xmm2"           & NL &
                       "vpxor %%xmm3, %%xmm2, %%xmm3"           & NL &
                       "vpextrq $1, %%xmm1, %%rax"              & NL &
                       "vpinsrq $1, %%rax, %%xmm3, %%xmm3"      & NL &
                       "vinserti128 $0, %%xmm3, %%ymm1, %%ymm1" & NL &
                       "vmovdqu %%ymm1, (%1)"                   & NL &
                       "vpextrq $0, %%xmm1, %0",
           Outputs  => (Unsigned_64'Asm_Output ("=r", r)),
           Inputs   => (System.Address'Asm_Input ("r", x.all'Address)));
      return r;
   end xrand64;

end xor128avx2;
