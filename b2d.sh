_b2d_id() {
  # XXX The path of boot2docker image is ~/dev/b2d
  vagrant global-status | awk '/dev\/b2d *$/ { print $1; }'
}

b2d() {
  local id=${BOOT2DOCKER_ID}
  local cmd="$1" && shift

  if test -z "$id" || ! docker version >/dev/null 2>&1; then
    id=$(_b2d_id)
  fi

  case "$cmd" in

  ""|config)
    local ip=$(vagrant ssh-config $id | sed -n "s/[ ]*HostName[ ]*//gp")
    export DOCKER_HOST="tcp://${ip}:2375"
    ;;

  ntp)
    vagrant ssh $id -- sudo /usr/local/bin/ntpclient -s -h pool.ntp.org
    vagrant ssh $id -- date -u
    date -u
    ;;

  id) echo $id ;;

  dir)
    # XXX The path of boot2docker image is ~/dev/b2d
    echo "${HOME}/dev/b2d"
    ;;

  ssh)
    vagrant ssh $id -- "$@"
    ;;

  status)
    vagrant status $id
    docker version
    ;;

  edit)
    gvim "$@" $(b2d dir)/Vagrantfile
    ;;

  clean)
    docker ps -qa | xargs docker rm
    docker images -qa | xargs docker rmi
    docker run --rm \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v /var/lib/docker:/var/lib/docker \
      planitar/docker-cleanup-volumes
    ;;

  *) vagrant "$cmd" $id "$@" ;;

  esac
}
