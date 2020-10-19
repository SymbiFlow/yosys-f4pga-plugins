/*
 *  yosys -- Yosys Open SYnthesis Suite
 *
 *  Copyright (C) 2020  The Symbiflow Authors
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */
#ifndef _CLOCKS_H_
#define _CLOCKS_H_

#include <vector>
#include "buffers.h"
#include "kernel/rtlil.h"

USING_YOSYS_NAMESPACE

class NaturalPropagation;
class BufferPropagation;
class ClockDividerPropagation;
class Propagation;

class Clock {
   public:
    Clock(const std::string& name, RTLIL::Wire* wire, float period,
          float rising_edge, float falling_edge);
    Clock(const std::string& name, std::vector<RTLIL::Wire*> wires,
          float period, float rising_edge, float falling_edge);
    Clock(RTLIL::Wire* wire, float period,
	    float rising_edge, float falling_edge);
    std::vector<RTLIL::Wire*> GetClockWires() { return clock_wires_; }
    const std::string& Name() const { return name_; }
    float Period() { return period_; }
    float RisingEdge() { return rising_edge_; }
    float FallingEdge() { return falling_edge_; }
    void UpdateClock(RTLIL::Wire* wire, float period, float rising_edge,
                     float falling_edge);
    static std::string ClockWireName(RTLIL::Wire* wire);

   private:
    std::string name_;
    std::vector<RTLIL::Wire*> clock_wires_;
    float period_;
    float rising_edge_;
    float falling_edge_;

    void UpdateWires(RTLIL::Wire* wire);
    void UpdatePeriod(float period);
    void UpdateWaveform(float rising_edge, float falling_edge);
};

class Clocks {
   public:
    void AddClock(const std::string& name, std::vector<RTLIL::Wire*> wires,
                  float period, float rising_edge, float falling_edge);
    void AddClock(const std::string& name, RTLIL::Wire* wire, float period,
                  float rising_edge, float falling_edge);
    void AddClock(Clock& clock);
    std::vector<std::string> GetClockNames();
    void Propagate(NaturalPropagation* pass);
    void Propagate(BufferPropagation* pass);
    void Propagate(ClockDividerPropagation* pass);
    void WriteSdc(std::ostream& file);
    const std::vector<Clock> GetClocks() {
	return clocks_;
    }
    void Clear() {
	clocks_.clear();
    }

   private:
    std::vector<Clock> clocks_;
    void PropagateThroughBuffer(Propagation* pass, Clock& clock,
                                Buffer buffer);
};

#endif  // _CLOCKS_H_
