using Test
import Pluto: PlutoRunner, Notebook, WorkspaceManager, Cell, ServerSession, update_run!

@testset "stdout/stderr IOContext" begin
    🍭 = ServerSession()
    🍭.options.evaluation.workspace_use_distributed = true

    notebook = Notebook(reduce(
        vcat,
        # $(repr(p)) rather than just $p for parseable output, e.g., Symbols with colons
        [
            Cell("($(repr(p))) in stdout"),
            Cell("($(repr(p))) in stderr"),
        ] for p in pairs(PlutoRunner.default_stdout_iocontext.dict)
    ))

    update_run!(🍭, notebook, notebook.cells)
    for cell in values(notebook.cells_dict)
        @test cell.output.body == "true"
    end

    WorkspaceManager.unmake_workspace((🍭, notebook))
end
