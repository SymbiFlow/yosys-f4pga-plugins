/*
 * Copyright 2020-2022 F4PGA Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 */
#ifndef _GET_CELLS_H_
#define _GET_CELLS_H_

#include "get_cmd.h"

USING_YOSYS_NAMESPACE

struct GetCells : public GetCmd {
    GetCells() : GetCmd("get_cells", "Print matching cells") {}

    std::string TypeName() override;
    std::string SelectionType() override;
    SelectionObjects ExtractSelection(RTLIL::Design *design, const CommandArgs &args) override;
};

#endif // GET_CELLS_H_
