# CLAUDE.md: 

Abstract—This document addresses the systematic and predictable errors exhibited by language models during code generation. These anomalies are non-random and highly recurrent, necessitating a formal codification of restrictive constraints rather than discretionary guidelines. The underlying thesis posits that while models generate superficially plausible code with high velocity, they lack the inherent capacity to evaluate technical validity. Consequently, rigorous procedural discipline must be enforced externally.

Index Terms—LLM-assisted programming, code review, software craftsmanship, minimal diffs, debugging, dependency hygiene.

## I. PRE-REQUISITE CODEBASE ANALYSIS

The primary catalyst for substandard model-generated code is the premature execution of modifications prior to a comprehensive evaluation of the existing architecture. Comprehensive examination, rather than superficial scanning, of the target files is required. Established architectural design patterns must be replicated, and existing import structures must be audited to ascertain the project's native dependencies; for example, utilizing native fetch mechanisms instead of introducing axios where inappropriate. In the absence of an established pattern, formal clarification must be sought rather than relying on conjecture.

## II. ANALYTICAL PREPARATION PRIOR TO IMPLEMENTATION

Architectural requirements must be fully resolved prior to code execution. Explicitly define all operational assumptions (e.g., specifying the precise modality of "authentication" from among various alternatives) and document the associated technical trade-offs. When encountering structural ambiguity, cease operations to solicit clarification rather than introducing speculative syntax; such speculative code routinely bypasses superficial reviews but fails under critical operational conditions.

## III. ARCHITECTURAL SIMPLICITY

Implement the minimal code increment required to resolve the immediate problem, eschewing speculative generalizations for hypothetical future requirements.  
Avoid premature abstractions, omit exception handling for non-viable error states, and utilize hardcoded values until configuration parameters are empirically justified. An abstraction is structurally over-engineered if its presence is justified solely by potential future utility.

## IV. TACTICAL MODIFICATIONS

The scope of the diff must remain strictly constrained to the assigned task. Refrain from modifying unassigned components, adhere to the established stylistic conventions, and avoid global formatting adjustments; automated formatters obscure critical logic alterations within voluminous trivial changes. Every line modification must be directly justified by the primary task. If a change is predicated on coincidental proximity ("while I was in there"), the modification must be reverted.

## V. VALIDATION AND VERIFICATION

Empirical testing serves as the critical mechanism to reconcile the disparity between verified functionality and assumed correctness. When resolving an anomaly, developers must implement a failing test case to observe the deficit prior to applying remediation; this sequence confirms that the root cause, rather than a superficial symptom, has been addressed. Testing efforts must target components susceptible to failure, rather than trivial operations such as constructor field assignments. Test execution complexity should be interpreted as an architectural diagnostic indicator rather than a justification for omission.

## VI. OBJECTIVE-DRIVEN EXECUTION

Every technical initiative requires predefined success criteria prior to implementation. Vague objectives such as "add validation" must be operationalized as explicit requirements, such as "reject missing or malformed email parameters, return a 400 Bad Request status with an explicit payload, and validate both execution paths." For multi-stage procedures, the strategic plan must be articulated initially to facilitate user oversight and mitigate the risk of misaligned implementation strategies.

## VII. SYSTEMATIC DEBUGGING

Upon system failure, conduct a rigorous investigation rather than employing speculative adjustments. Analyze the complete error payload and associated stack trace, reproduce the anomaly prior to introducing modifications, and alter variables strictly in isolation. Do not mitigate unexpected null values by simply applying null checks; determine the underlying cause of the null state to prevent the bug from migrating to distinct components.

## VIII. DEPENDENCY MANAGEMENT

Third-party dependencies represent permanent additions to the codebase that are external to internal control mechanisms. Prior to introduction, evaluate whether existing internal modules or the language standard library can fulfill the requirement (e.g., utilizing standard crypto utilities over external UUID packages). When a dependency is introduced, document the rationale clearly to ensure the decision is transparently reflected within the manifest.

## IX. PROTOCOLS FOR COMMUNICATION

Provide a concise summary of the engineering actions performed along with their underlying technical rationale, rather than submitting isolated code blocks. Document potential technical concerns even when adhering strictly to specifications, and communicate uncertainty with high precision. Assertions such as "I am not sure this library supports streaming" define clear verification objectives, whereas "I think this should work" lacks actionable technical utility.

## X. RECURRENT FAILURE ARCHETYPES

Several systematic failure modes occur with sufficient frequency to warrant explicit categorization: the Scope Creep (unwarranted restructuring of adjacent codebases), the Premature Abstraction (failure to establish repeated patterns before abstracting), the Optimistic Execution Path (exclusive handling of successful conditions while ignoring server errors), and the Cascading Refactor (a localized fix that unsustainably propagates across multiple files). Upon identifying any of these behaviors, immediate cessation of the current approach is required.

© 2028 A. Karpathy. Personal use of this material is permitted. This is an independent reformatting of the author's working notes on LLM-assisted programming (CL.41/28 mod. 9200625\) into a conference-style document. Freely available, rates subject to revision at the model's discretion.

—

# Graph Engineering: From Karpathy's Loops to Shared Knowledge Graphs

A short PDF cross-references three pieces of 2026 work — Karpathy's autoresearch loop, his AgentHub sketch, and Anthropic's Knowledge Graph Construction Cookbook — and walks through the missing layer that turns single-agent loops into collaborative swarms. It's an independent synthesis, not a Karpathy paper, but the architectural progression is precise and worth taking seriously. The pipeline has six steps, and the step that matters most is the one your loop is currently skipping.

## The bottleneck isn't the next model call

Autoresearch runs for \~5 minutes per experiment. Karpathy's reported 700 experiments over two days produced around 20 retained optimizations, all stored in a Git history that doubles as an experiment lineage. 1\. The loop is real and it works—karpathy/autoresearch had passed 86,000 stars by mid-2026. The limitation is in the verb "runs." A single agent, single direction, single machine. Every decision that didn't make it into train.py is forgotten between turns.

The progression described in the synthesis is the part worth reading. Three moves, each unlocking a new bottleneck:

* Loop externalizes iteration and evaluation.   
* Swarm externalizes parallel search.   
* Graph externalizes shared facts, provenance, and cross-session memory. 

The whole point is that the graph layer is what turns a swarm from a fireworks display into a research community. Without it, every worker rebuilds context from scratch; the orchestrator's transcript becomes the system of record.

—

## Step 1: build one loop.

The starter pattern is just “reflective\_task”: generate, evaluate, revise, capped by a round limit.

```py
def reflective_task(task, gen, eval, max_rounds=3):
    versions = [gen(task)]
    for _ in range(max_rounds):
        review = eval(task, versions[-1])
        if review["decision"] == "approve":
            return {"result": versions[-1], "versions": versions}
        versions.append(
            gen(task, prior=versions[-1], instructions=review["changes"])
        )
    return {"result": versions[-1], "status": "iteration_limit"}
```

The minimum requirements are stricter than they look:

* The output must be verifiable. If the task can't be evaluated, autonomy is useless.   
* The action must be reversible. Git reset returns to the last retained state.   
* The horizon must be short. Five-minute training runs produce frequent feedback.   
* The environment must be bounded. A repo bounds the action space. 

autoresearch satisfies all four. The 630-line core encodes that contract: prepare.py (fixed), train.py (mutable), program.md (the natural-language control spec). Karpathy's program.md template establishes the mutable-vs-protected file boundary, the metric and direction, the experiment budget, the run command, output parsing, crash handling, commit/revert rules, logging, human escalation policy, and exhaustion criteria. 2

That template generalizes to anything runnable. A test-fixing agent needs the same boundary: which files can it touch, what counts as success, and what's the wall-clock budget.

—

## Step 2: go parallel 

Parallel work only pays off when subtasks are independent. The Day-2 gains are from giving agents their own worktree so they don't clobber each other. The Day-3 gains are from giving them a reducer so the orchestrator doesn't get stuck summarising.

Anthropic's Dynamic Workflows formalize this in 2026: Claude writes a JavaScript orchestration program, fanning out up to 16 concurrent sub-agents per call, hard-capped at 1,000 per workflow, each with fresh context. 3

```javascript
const files = await tools.glob("src/**/*.ts");
const audits = await gather(
  files.map((file) =>
    spawn("auditor", {
      file,
      instructions: "Inspect for race conditions. Return JSON.",
    }),
  ),
  { concurrency: 16 },
);
const suspicious = audits.filter((r) => r.confidence >= 0.70);
const reviews = await gather(
  suspicious.map((r) =>
    spawn("reviewer", { report: r, instructions: "Try to refute this finding." }),
  ),
  { concurrency: 16 },
);
return await spawn("synthesizer", {
  audits,
  reviews,
  instructions: "Produce one cited report.",
});
```

Five control points matter more than the rest of the script:

* Define a reducer before fan-out. Without a plan for combining output, you have collected parallel debris.   
* Cap concurrency and total workers. Token budgets outrun rate limiters.   
* Per-worker timeouts and retries. Stuck workers shouldn't pin the budget.   
* Evidence contract per subtask. Free-form text is hard to synthesise.   
* Final evaluator gate. Sub-agent claims need a separate prompt to grade them. 

A 1,000-sub-agent run at high effort can cost tens of dollars. Plan for that.

—

## Step 3: add a knowledge graph

Parallel work also creates the redundancy problem. Two workers find the same vendor. Three workers argue about the same incident. Without a shared layer, the orchestrator's context fills up, summaries drift, and the next run starts from a corrupted transcript. A typed knowledge graph is the layer that fixes it.

The Anthropic Cookbook builds one in four steps that map cleanly to production. 4

| Stage | Model | Job |
| :---- | :---- | :---- |
| Extract | Haiku | Schema-constrained call returns typed entities and S-P-O relations |
| Resolve | Sonnet | Cluster surface forms, merge aliases, build canonical IDs |
| Assemble | code | Build a MultiDiGraph with provenance on every edge |
| Query | Sonnet | Serialise a bounded subgraph and reason with edge citations |

The Pydantic schema is the entire training set for the entity extractor. A classical NLP pipeline with NER, coreference, and a relation classifier collapses to a structured-output prompt per document.

```py
class Entity(BaseModel):
    name: str
    type: EntityType
    description: str

class Relation(BaseModel):
    source: str
    predicate: str
    target: str

def extract(text, client):
    response = client.messages.parse(
        model="claude-haiku-4-5",
        messages=[{"role": "user", "content": PROMPT.format(text=text)}],
        output_format=ExtractedGraph,
    )
    return response.parsed_output
```

Two operational rules you cannot skip:

* Resolution must be reversible. A false merge contaminates every downstream traversal. Keep aliases, source documents, confidence, and the run that created the merge.   
    
* Queries should be bounded. A multi-hop answer should identify starting entities, traverse a bounded neighborhood, filter by edge type or date, and serialize within a token budget. Edges need stable IDs so they can be cited. 

The pattern on the storage side stays compact: a NetworkX MultiDiGraph carries nodes with (name, entity\_type, description, source\_docs, aliases) and edges with (predicate, source\_doc, confidence). Pydantic and NetworkX are interchangeable with anything that exposes a similar shape.

—

## Step 4: ground the evaluator against graph edges

A free-form critic writes "this claim is unsupported." A graph-grounded evaluator tells you exactly which edge is missing.

```json
{
  "decision": "revise",
  "claim": "Vendor X supplied the component in Incident Y",
  "reason": "No supported path from Vendor X to Y",
  "required_evidence": [
    "A source-backed supplied relation",
    "A source-backed involved_in relation"
  ]
}
```

This is what separates "looks plausible" feedback from "here is what must be true" feedback. The evaluator checks claims against supported\_by edges and treats missing edges as defects, not opinions.

For graph autoresearch, the evaluator pipeline looks identical to autoresearch's: read the current extraction prompt and score history, propose one prompt or schema change, run extraction against the gold set, compute precision/recall/F1/cost/latency, keep if better, and revert otherwise. The artifact being optimized is not train.py. It's the extraction prompt, ontology, resolution policy, and query serializer.

—

## Step 5: plug the graph in as shared memory

Workers publish structured graph updates. Synthesizers traverse the graph to combine findings even when no worker saw every source document. A monitoring layer tracks trends, not point scores.

```py
@dataclass
class GraphUpdate:
    nodes: list[dict]
    edges: list[dict]
    run_id: str
    agent_id: str

def publish(update, graph, validator):
    validator.check_schema(update.nodes, update.edges)
    validator.check_provenance(update.nodes, update.edges, update.run_id)
    with graph.transaction() as tx:
        tx.upsert_versioned_nodes(update.nodes)
        tx.add_edges(update.edges)
        tx.link_run(update.run_id, update.agent_id, update.nodes, update.edges)
        tx.commit()
```

The graph plays three roles simultaneously: shared memory, grounding layer, and persistent world model. The line that captures the distinction the most directly: the agent forgets, the graph does not.

Persistence is what enables long-running investigations, cross-session planning, incremental document ingestion, contradiction tracking, versioned decisions, audit trails, handoff between different models, and recovery after a failed run.

—

## Step 6: stop rebuilding context every session

The single most important architectural insight in the synthesis is the split between two graph layers.

* The commit DAG remembers which work descends from which experiment. It answers: What changed? Which agent produced it? Which lineages are alive?  
* The knowledge graph remembers which claims connect to which entities and sources. It answers: Which entities exist? How are they related? Which sources support a relation? Which claims conflict? 

Production platforms keep both, connected:

*(agent\_run\_183)*  
  ├─ produced ──\> (claim\_441)  
  ├─ modified ──\> (commit\_a81f)  
  └─ evaluated\_by ──\> (evaluation\_92)  
*(claim\_441)*  
  ├─ about ──\> (entity\_autoresearch)  
  ├─ supported\_by ──\> (source\_readme)  
  └─ supersedes ──\> (claim\_238)

The container commit DAG handles "what happened in run 183", the knowledge graph handles "what is true about autoresearch". The two graphs answer orthogonal questions. Collapsing them into one is what produces unmaintainable context dumps.

Context construction should then be a subgraph problem, not a transcript problem:

1. Resolve entities mentioned in the task.   
2. Expand one or two hops over allowed edge types.   
3. Include current artifact versions.   
4. Prioritise recent verified claims.   
5. Include conflicts and uncertainty.   
6. Serialise within the token budget.   
7. Attach stable edge identifiers for citation. 

This is the move that makes overnight loops practical. The graph keeps state while the model sleeps.

—

## The five-plane production architecture

A production implementation separates five planes to avoid the trap of "the chat transcript became the database":

| Plane | Job |
| :---- | :---- |
| Control | Receives objectives, creates plans, allocates budgets, starts workflows, decides when to stop |
| Execution | Runs tools, tests, training jobs, code modifications, sub-agents in isolated environments |
| Artifact | Stores plans, drafts, code changes, reports, metrics, evaluations as immutable versions |
| Graph | Stores entities, claims, relations, provenance, lineage, and task dependencies |
| Evaluation | Runs deterministic checks, model evaluators, statistical scorers, and human review |

This is what lets loops keep running unattended. Each plane is replaceable. The state that matters lives in artifacts and the graph, not in the prompt window.

## A practical six-month build path

This isn't a weekend project. Here's the order the synthesis recommends and the rough cost curve:

| Stage | Time | Complexity | Exit criterion |
| :---- | :---- | :---- | :---- |
| Reflective loop | Day 1 | Low | Measured quality improvement on one task |
| Tool use | Day 2 | Low | Tool reduces a known error class |
| Planning | Week 1 | Medium | Variable tasks complete end-to-end |
| Multi-agent | Week 2 | Medium | Role split beats single agent on a benchmark |
| Persistent graph | Month 1 | High | Cross-session queries work |
| Swarm workflow | Month 2 | High | Wall-clock gain without quality loss |

Start smaller than you think. Pick one task whose output can be evaluated. Add storage. Add tools. Add one evaluator. Add a plan. Add a second role. Then think about graphs.

—

## When NOT to build a graph

Don't introduce a knowledge graph because the system has agents. You don't need one when:

* Tasks are independent.   
* No cross-session state is required.   
* Answers depend on one document. Relations are fixed and simple.   
* A relational table answers every query.   
* Provenance is not needed.   
* Extraction errors would outweigh traversal value. 

A graph earns its cost when connected queries, evolving relations, provenance, and shared world state are central.

—

## The honest limits

Four things this architecture cannot fix for you, all of which the synthesis names explicitly:

* A loop amplifies the objective and evaluator chosen by the builder. A bad metric accelerates bad behavior.   
* A graph amplifies the ontology and source policy. A biased corpus produces a biased graph.   
* Dynamic workflows are expensive. A 1,000-sub-agent run is tens of dollars; parallel workers also create correlated errors.   
* Fragmentation can reduce quality. Architecture design, narrative writing, and tightly coupled refactors may degrade when sliced into isolated units. 

The architectural pattern is sound. The claim of "just add a graph and the swarm works" is wrong. The graph is the substrate for explicit state, durable memory, and evidence. The human still owns the rubric, the ontology, and the rotation policy.  
—

## Summary

* Karpathy's autoresearch is a 630-line, \~5-minute-per-iteration loop. It works because the output is verifiable and the action is reversible.   
* AgentHub is the sketch that turns one direction into a search across many branches, with commits as nodes and parent links as edges.   
* Anthropic's cookbook supplies the typed knowledge graph that holds entities, claims, sources, and relations across sessions.   
* The progression is: loop → swarm → graph. Each layer addresses a different bottleneck.   
* The graph is shared memory and a grounding layer at once, but only when traversal, persistence, and provenance all matter.   
* Implementation timeline: day 1 to month 2; six stages.   
* A false merge or biased ontology contaminates everything. Provenance and reversible resolution are non-negotiable. 

The bottleneck is rarely the next model call. It is where you place memory and evaluation. The graph is the answer to both.

—

**Source note on this post:** The framing of "six steps from loop to graph" comes from a short independent synthesis PDF that cross-references the work cited above. The PDF is not affiliated with or endorsed by Andrej Karpathy, Anthropic, or any other organization mentioned; it is a third-party summary assembled for study. All concrete facts in the post (file boundaries, line counts, concurrency limits, model defaults, versioned graph schema, and the citation graphs above) trace back to the primary sources cited inline. The original PDF can be inspected at the source the user shared.

1. Andrej Karpathy, autoresearch — GitHub repository, March 2026; \~630 lines in core training code; reported 700 experiments over two days with \~20 retained optimizations.   
     
2. Karpathy, autoresearch README — prepare.py (fixed), train.py (mutable), program.md (natural-language control spec).   
     
3. Anthropic, Dynamic Workflows — Claude-written JavaScript orchestration program spawning sub-agents with fresh context, concurrency 16, hard cap 1,000 per workflow, May 2026\.   
     
4. Anthropic, Knowledge Graph Construction Cookbook — four-stage pipeline (Extract → Resolve → Assemble → Query) with Pydantic schemas and NetworkX MultiDiGraph storage.
