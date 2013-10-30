# My install Bash script for Vagrant.
Much like [Jeffrey Way](https://github.com/JeffreyWay/Vagrant-Setup), [Eric Barnes](https://github.com/ericbarnes/Vagrant-Setup) and [Josh Manders](https://github.com/killswitch/Vagrant-Setup), this is my version of Jeffrey's Vagrant Setup.

The same as [Josh Manders'](https://github.com/killswitch/Vagrant-Setup) (with Nginx) but with my editions:
* Debian (wheezy64)
* Updated shared folders mount (as of I've experiensed problems with permissions with original setup)
* Private network on IP 33.33.33.33

If establishing of private network causes errors in VirtualBox, run (if on Mac):
```
sudo /Library/StartupItems/VirtualBox/VirtualBox restart
```
(see https://github.com/mitchellh/vagrant/issues/2392#issuecomment-27367698)

## Thanks goes to the following references:
- [https://laracasts.com/lessons/vagrant-and-laravel](https://laracasts.com/lessons/vagrant-and-laravel)
- [https://gist.github.com/fideloper/7074502](https://gist.github.com/fideloper/7074502)
- [Setting Up Vagrant With Laravel 4](http://culttt.com/2013/06/17/setting-up-vagrant-with-laravel-4/)
- [How to Install the Latest Version of PHP 5.5 on Ubuntu](http://www.dev-metal.com/how-to-setup-latest-version-of-php-5-5-on-ubuntu-12-04-lts/)
