// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#include "toolchain/diagnostics/format_providers.h"
#include "toolchain/parse/context.h"
#include "toolchain/parse/handle.h"

namespace Carbon::Parse {

auto HandleBindingPattern(Context& context) -> void {
  auto state = context.PopState();

  // Parameters may have keywords prefixing the pattern. They become the parent
  // for the full BindingPattern.
  if (auto token = context.ConsumeIf(Lex::TokenKind::Template)) {
    context.PushState({.state = State::BindingPatternTemplate,
                       .token = *token,
                       .subtree_start = state.subtree_start});
  }

  if (auto token = context.ConsumeIf(Lex::TokenKind::Addr)) {
    context.PushState({.state = State::BindingPatternAddr,
                       .token = *token,
                       .subtree_start = state.subtree_start});
  }

  // Handle an invalid pattern introducer for parameters and variables.
  auto on_error = [&](bool expected_name) {
    if (!state.has_error) {
      CARBON_DIAGNOSTIC(ExpectedBindingPattern, Error,
                        "expected {0:name|`:` or `:!`} in binding pattern",
                        BoolAsSelect);
      context.emitter().Emit(*context.position(), ExpectedBindingPattern,
                             expected_name);
      state.has_error = true;
    }
  };

  // The first item should be an identifier or `self`.
  bool has_name = false;
  if (auto identifier = context.ConsumeIf(Lex::TokenKind::Identifier)) {
    context.AddLeafNode(NodeKind::IdentifierName, *identifier);
    has_name = true;
  } else if (auto self =
                 context.ConsumeIf(Lex::TokenKind::SelfValueIdentifier)) {
    // Checking will validate the `self` is only declared in the implicit
    // parameter list of a function.
    context.AddLeafNode(NodeKind::SelfValueName, *self);
    has_name = true;
  }
  if (!has_name) {
    // Add a placeholder for the name.
    context.AddLeafNode(NodeKind::IdentifierName, *context.position(),
                        /*has_error=*/true);
    on_error(/*expected_name=*/true);
  }

  if (auto kind = context.PositionKind();
      kind == Lex::TokenKind::Colon || kind == Lex::TokenKind::ColonExclaim) {
    state.state = kind == Lex::TokenKind::Colon
                      ? State::BindingPatternFinishAsRegular
                      : State::BindingPatternFinishAsGeneric;
    // Use the `:` or `:!` for the root node.
    state.token = context.Consume();
    context.PushState(state);
    context.PushStateForExpr(PrecedenceGroup::ForType());
  } else {
    on_error(/*expected_name=*/false);
    // Add a substitute for a type node.
    context.AddInvalidParse(*context.position());
    context.PushState(state, State::BindingPatternFinishAsRegular);
  }
}

// Handles BindingPatternFinishAs(Generic|Regular).
static auto HandleBindingPatternFinish(Context& context, NodeKind node_kind)
    -> void {
  auto state = context.PopState();

  context.AddNode(node_kind, state.token, state.has_error);

  // Propagate errors to the parent state so that they can take different
  // actions on invalid patterns.
  if (state.has_error) {
    context.ReturnErrorOnState();
  }
}

auto HandleBindingPatternFinishAsGeneric(Context& context) -> void {
  HandleBindingPatternFinish(context, NodeKind::CompileTimeBindingPattern);
}

auto HandleBindingPatternFinishAsRegular(Context& context) -> void {
  HandleBindingPatternFinish(context, NodeKind::BindingPattern);
}

auto HandleBindingPatternAddr(Context& context) -> void {
  auto state = context.PopState();

  context.AddNode(NodeKind::Addr, state.token, state.has_error);

  // If an error was encountered, propagate it while adding a node.
  if (state.has_error) {
    context.ReturnErrorOnState();
  }
}

auto HandleBindingPatternTemplate(Context& context) -> void {
  auto state = context.PopState();

  context.AddNode(NodeKind::Template, state.token, state.has_error);

  // If an error was encountered, propagate it while adding a node.
  if (state.has_error) {
    context.ReturnErrorOnState();
  }
}

}  // namespace Carbon::Parse
