# ~/.bash_profile

# NOTE: run source ~/.bash_profile for the commands to work!

[[ -f ~/.bashrc ]] && . ~/.bashrc

# runs amass passively, saves the results to .json
am(){ 
    amass enum --passive -d $1 -json $1.json
    jq .name $1.json | sed "s/\"//g"| httprobe -c 60 | tee -a $1-domains.txt
}

# scans for subdomains using certspotter's api 
certspotter(){
    curl -s https://certspotter.com/api/v0/certs\?domain\=$1 | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $1
} 

# scans for subdomains using crtsh's api 
crtsh(){
    curl -s https://crt.sh/?Identity=%.$1 | grep ">*.$1" | sed 's/<[/]*[TB][DR]>/\n/g' | grep -vE "<|^[\*]*[\.]*$1" | sort -u | awk 'NF'
}

# counts all found subdomains, total and alive 
domaincount(){
    echo "Total: " 
    cat $1 | wc -l
    echo " "
    echo "Alive: " 
    cat $2 | wc -l
}
