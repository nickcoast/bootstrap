alias ls='ls -F --color=auto --show-control-chars'
alias ll='ls -l'


# ls mods
alias 'lg'='ls | grep'
alias 'lsg'='ls | grep'
alias 'llg'='ll | grep'
alias 'lll'='ll | less'
alias 'llh'='ls -lh'
alias 'lla'="ll -a"
alias 'llah'='ll -h'
alias 'llal'='ll -a | less'
alias 'llahl'='ll -h | less'
alias 'llahg'='ll -ah | grep'
#displays all in MiB
alias 'llahm'='ll -ah --block-size=M'

# find mods
alias fd='find -maxdepth 1 -type d'
alias ff='find -maxdepth 1 -type f'
alias fde='find -type d -exec'
alias ffe='find -type f -exec'

# cd mods
alias '..'='cd ..'
alias '...'='cd ../..'
alias '.3'='cd ../../..'
alias '.4'='cd ../../../..'

alias 'www'='cd /var/www/html'
alias 'vag'='cd /vagrant'

# use this to grep documents and strip out comments
alias nocomment="grep -Ev '^\s*(#|$)'"

#vi
alias vi='vim'
alias svi='sudo vim'
alias svim='sudo vim'

#assuming you don't care about insecure passwords
alias mysqlv='mysql -u root -pvagrant'
#new 2021-11-03
alias mysql='mysql --login-path=local -A'

alias phperr='vim /var/log/php/php_errors.log'
