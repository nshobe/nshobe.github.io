---
layout: page
title: Random Passwords
permalink: /randompass/
tags: SysAdmin Code
---
## /dev/urandom
Serious blew my mind first time I used it.

Run this, and get ready to hit Ctl+C
```bash
cat /dev/urandom | tr -dc 'a-zA-Z0-9'
```

Cat starts spitting output from the device and trim makes sure you're only getting alphanumeric. But you likely want something of a certain size. `fold` is a convinient way to do that since it'll limit each line by a size, and then head the output so it just stops at the first carriage return of intput.

```bash
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1
```
And viola, you have a random alphanumeric string.

## Convert to hash
A random password is nice, but by itself isn't always the most secure. Most password systems generate a hash based off the key, so that the check can be done via math versus string matching, which allows the password to not be directly stored anywhere.

A simple example of a MD5 hash is to use openssl which is installed on most systems.
```bash
openssl passwd -1 -salt test thinggy
```
or better yet, create it as a whole set of commands, maybe even wrap it into a function and drop it into your pofile.
```bash
SALT=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1)
PASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 18 | head -n 1)
openssl passwd -1 -salt $SALT $PASS
```

But: That's a weak hash algorythm by today's standards.

You can generate a much more modern SHA512 with a python one liner like this:
```bash
python -c 'import crypt; print(crypt.crypt("$PASS", crypt.mksalt(crypt.METHOD_SHA512)))'
```
And that will dump you out a full output that you could drop into a shadow file, or a database provided the lookup knows how to speak SHA512. Note that there's a salt in there that was randomly generated.

