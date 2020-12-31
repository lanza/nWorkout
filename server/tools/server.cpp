#include <iostream>

#include <Person.hpp>
#include <Utility.hpp>

#include <llvm/Support/CommandLine.h>

#include <dbg.h>

#include <httplib.h>

static llvm::cl::OptionCategory MuffinCategory("muffin");
llvm::cl::opt<bool> MuffinIsCool("muffin-is-cool",
                                 llvm::cl::desc("Muffin is a cool dog."),
                                 llvm::cl::init(true));

int main(int Argc, char **Argv) {
  if (!llvm::cl::ParseCommandLineOptions(Argc, Argv)) {
    llvm::cl::PrintOptionValues();
  }

  using namespace httplib;

  httplib::Server S;

  S.Get("/hi", [](const Request &Req, Response &Res) {
    Res.set_content("Hello World!", "text/plain");
  });

  S.Get(R"(/numbers/(\d+))", [&](const Request &Req, Response &res) {
    auto Numbers = Req.matches[1];
    res.set_content(Numbers, "text/plain");
  });

  S.Get("/body-header-param", [](const Request &Req, Response &Res) {
    if (Req.has_header("Content-Length"))
      auto Val = Req.get_header_value("Content-Length");
    if (Req.has_param("key"))
      auto Val = Req.get_param_value("key");

    Res.set_content(Req.body, "text/plain");
  });

  S.Get("/stop", [&](const Request &Req, Response &Res) { S.stop(); });

  S.listen("localhost", 1234);
  return 0;
}
