-- Ada-program for MT19937-64. Coded by Wojciech Lawren.

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

with Interfaces; use Interfaces;

package MTavx with
   No_Elaboration_Code_All,
   Pure
is
   H1 : constant Unsigned_64 := 16#5555_5555_5555_5555#;
   H2 : constant Unsigned_64 := 16#71D6_7FFF_EDA6_0000#;
   H3 : constant Unsigned_64 := 16#FFF7_EEE0_0000_0000#;

   function genrand64 (x : in Unsigned_64) return Unsigned_64 with No_Inline;

end MTavx;
