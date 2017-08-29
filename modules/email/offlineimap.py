#!/usr/bin/env python2

from subprocess import check_output

def get_pass(account):
    return check_output("pass key " + account, shell=True).strip("\n")

def get_user(account):
    return check_output("pass user " + account, shell=True).strip("\n")
