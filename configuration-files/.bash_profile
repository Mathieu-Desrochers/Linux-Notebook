setfont ter-v18n

export LD_LIBRARY_PATH=/usr/local/lib

google_search()
{
  lynx -cfg=~/.lynx.cfg www.google.com/search?q=$1
}

alias g="google_search"
