#!/usr/bin/expect -f

log_user 0
set timeout 3
set password [lindex $argv 0]

spawn mysql_secure_installation

expect "Enter current password for root (enter for none):" { send -- "\r";
        expect "OK, successfully used password, moving on..." {
                expect "Set root password" { send -- "y\r";
                        expect "New password:" { send -- "$password\r";
                                expect "Re-enter new password:" { send -- "$password\n";
                                        expect "Remove anonymous users" { send -- "y\r";
                                                expect "Disallow root login remotely" { send -- "y\r";
                                                        expect "Remove test database and access to it" { send -- "y\r";
                                                                expect "Reload privilege tables now" { send -- "y\r";
                                                                        expect "Thanks for using MySQL!" {
                                                                                exit 0;
                                                                        }
                                                                }
                                                        }
                                                }
                                        }
                                }
                        }
                }
        }
}

exit 1;
