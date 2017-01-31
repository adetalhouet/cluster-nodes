# Copyright (c) 2017 Alexis de Talhouët
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

FROM ubuntu:trusty

# As we can't mount folders through docker-compose without 
# having them in sync with the host, we're using a 
# Dockerfile to bypass this limitation

COPY opendaylight /root/opendaylight
COPY scripts /root/scripts