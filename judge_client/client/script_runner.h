/*
 * Copyright 2007 Xu, Chuan <xuchuan@gmail.com>
 *
 * This file is part of ZOJ.
 *
 * ZOJ is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * ZOJ is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with ZOJ. if not, see <http://www.gnu.org/licenses/>.
 */

#ifndef __SCRIPT_RUNNER_H__
#define __SCRIPT_RUNNER_H__

#include "native_runner.h"

class TraceCallback;

class ScriptRunner : public NativeRunner {
  public:
    ScriptRunner(int sock, int time_limit, int memory_limit, int output_limit, int uid, int gid, const char* commands[])
        : NativeRunner(sock, time_limit, memory_limit, output_limit, uid, gid) {
        this->commands = commands;
    }

  private:
    virtual void InternalRun();
    const char** commands;

  friend class ScriptRunnerTest;    
};

#endif // __SCRIPT_RUNNER_H__
