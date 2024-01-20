# Copyright 2024 Sovereignty A.R.T.I.A.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#    http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Description: Google Authenticator activation script -- will force verification code prompt

##!!!!!! THIS SHOULD BE RUN AFTER YOU HAVE ALREADY SET UP GOOGLE AUTHENTICATOR FOR EACH USER !!!!!!!!!!!!

## Force verification during 'su' operations
echo "auth            required        pam_google_authenticator.so" >> /etc/pam.d/su

## Force verfication during 'sudo' optations
sed -i '2i\auth       required     pam_google_authenticator.so' /etc/pam.d/sudo

#/#/EOF\#\#