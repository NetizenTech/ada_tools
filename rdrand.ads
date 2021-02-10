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

with Interfaces; use Interfaces;

package rdrand with
   No_Elaboration_Code_All,
   Pure
is

   function rand64 return Unsigned_64 with No_Inline;

   function rand32 return Unsigned_32 with No_Inline;

   function rand16 return Unsigned_16 with No_Inline;

   function seed64 return Unsigned_64 with No_Inline;

   function seed32 return Unsigned_32 with No_Inline;

   function seed16 return Unsigned_16 with No_Inline;

end rdrand;
