

     I2P on Tails script v0.1    
          September 2021         
                                 
 --------------------------------
     Experimental but working    
      on latest Tails version    
 --------------------------------
                                 
     Created by DeSnake          
            AlphaBay Marketplace 
        




--------------------------------------------------------

 
@ WARNING WARNING WARNING & Terms and Conditions @ 


The script/hack/patch code is EXPERIMENTAL. There are no warranties or guarantees for it.

Use at your own discretion. I am not responsible if you fuck up your system in any way or
if it leads to unexpected results.

The code is open source and can be copied/modified as long as you include credits. If you
want to make any changes/additions it is best to contact me and I will review them and
if good, I will add them to the next version of this script. The script is in no way
perfect but it gives a good base to build on to get I2P support back in Tails OS.

For Whonix, other Linux distributions, Windows or smartphones please refer
to the I2Pd documentation pages located at https://i2pd.readthedocs.io/en/latest/
or FAQ/How-To guides over at AlphaBay Marketplace:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

http://tnaefzkcnhryeusi7hdpqujqiqmnbtah3dmjcg3gvezohunjuxbq.b32.i2p
http://alphabay522szl32u4ci5e3iokdsyth56ei7rwngr2wm7i5jo54j2eid.onion
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJhAqp1AAoJEBHEgMJRWRsQrTMP/jayYqUgEdWWmD4+HhyYklsk
vsdHS5i03ZRk1vMP6PDDtqXg6kfBDKiCFiczCsasjKUOhF/CgBC6qAV92tGeetGs
+auDgSmi1RWbtuaPLyz+IEgOyk7HrjS7FQsaBX/OhPcYVxlaFxQE5XOz1fnmGyRE
EDtXCk2/jlUdJuPtJCNbMKCRG+5ElMCcYilt1tcqp7WA0pqAuAPOJJ68yDS198T/
IGN+vPwLDWuaBtpO5sr3hiqKpos1s79QQouUHx+FpHVGxKPZ1sRY+NXdvECAalKt
ZgGxm8c1XSvoBZRtyhcA90irzIjbFAVeKikTfDQJdNVj0SMKnJbxPQo716qRrPta
YnhockMisQ/QFadBtNsA+SUvhvaKzlwLKqeLOjd+disPLMumyHRznoGrfKwHV9iY
9dZgR4Lo10ofZYOgD4E5a1nrCsj8Ykt+Q8yWKLCBF+C+gxu7fZbTEF5QHijMRacJ
nEGW2fINBcknx4chVMaWZ0YvYm7I873XN7ijRPEsUvF0+/eY3MMdWwiuk9GVTQV4
OVz+e8J2yXk7VGrxIueKWoSqWVN9hegKH835a0v3fZpF8rJsEp8d4VQrn+hbP7Rv
6nAbxVRT9qENsTNQslFmjhRAKTTGzEY7xA3ZtuanLR3+CKrvl2U2gWA2fv4Wvk6w
Hpwgk319ImKyYHvoYZ6K
=VblM
-----END PGP SIGNATURE-----


--------------------------------------------------------

 
@ Requirements @ 

- Tails OS live or persistence (live recommended). 

Tails must be based on Debian 10 (4.XX).

Tails 5 (yet to be released) will be based on Debian 11, this script will need to be updated for it.
 
 
--------------------------------------------------------
 
 
@ Instructions @                                    
   
   
   
IMPORTANT: Close Tor Browser BEFORE running this script, preferrably do not initiate it to begin with.


                                                      
Follow instructions for enabling root account on Tails OS (live or persistance):

WARNING: You must be on the Welcome Screen before you login to Tails, this will not work while already logged in.

1. When the Welcome Screen appears, click on the Add Additional Setting (it is a plus looks like this -> + ) button.
2. Choose Administration Password in the Additional Settings dialog.
3. Specify a password of your choice in both the Administration Password and Confirm text boxes then click Add.
4. Now login to Tails as you normally do.
5. VERY IMPORTANT: Do not start the Tor Browser on startup. Connection to the Tor network with the assistant that is fine but DO NOT START TOR BROWSER YET. Complete all steps first.

Once Tails has loaded you have two options to bring up the root terminal which you need in order to run the script.
Option 1: Choose Applications > System Tools > Root Terminal.
Option 2: Execute in a terminal:   sudo -i

In that session you need to navigate to where this script is stored. 

Now you can finally run the script as you ran this script and you should not get this message. If you do get it read carefully and execute each step again.

--------------------------------------------------------


@ Troubleshooting @

If you start Tor Browser but it does not work type "about:config" (without quotes) in the search address bar, click I accept the risks and then in the top
bar search for the following settings:


Setting: extensions.torbutton.use_nontor_proxy
Value: true

Setting: network.proxy.allow_hijacking_localhost
Value: false

Setting: network.proxy.socks
Value:

(the one above the field MUST be empty)

Setting: network.proxy.autoconfig_url
Value: "http://127.0.0.1:8181/proxy.pac"

(the one above you MUST add the quotes ")

Setting: network.proxy.type
Value: 2

If they are not configured then input each one of them. Try visiting http://127.0.0.1:7070 you should see the I2Pd Router console.

Now try to visit any .b32.i2p address. Addresses such as http://stats.i2p and http://zzz.i2p will NOT be saved previously in your address book so you must use full length .i2p addresses.

--------------------------------------------------------


@ Updates @

At some point you will need to update I2Pd. Current version: i2pd_2.39.0

You will need to go to https://github.com/PurpleI2P/i2pd/releases and grab the link to the latest release. You should look for file which says something
like buster amd64.deb.

Now you have 2 choices. First choice is to do  systemctl stop i2pd  then   dpkg -i i2pd_XXXX-1buster1_amd64.deb where XXX is the numbers of the version.

Second choice is to run  sudo apt-get remove --purge i2p* , add the new link to the install_i2pd.sh file and corresponding dpkg -i etc and rerun the script.

Either method works fine.

--------------------------------------------------------


@ Credits @
Credits to the following resources and people which I used/worked with to make this happen:
Konrad Bächler, Tails devs, I2P devs, I2Pd devs, Tails documentation, I2Pd documentation, Tor documentation, Tails Gitlab repo
