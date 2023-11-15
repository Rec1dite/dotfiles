# Place your key bindings in this file to override the defaults
[
    #===== DISABLE DEFAULTS =====#
    {
        key = "ctrl+p";
        command = "-extension.vim_ctrl+p";
        when = "editorTextFocus && vim.active && vim.use<C-p> && !inDebugRepl || vim.active && vim.use<C-p> && !inDebugRepl && vim.mode == 'CommandlineInProgress' || vim.active && vim.use<C-p> && !inDebugRepl && vim.mode == 'SearchInProgressMode'";
    }
    {
        key = "ctrl+b";
        command = "-extension.vim_ctrl+b";
        when = "editorTextFocus && vim.active && vim.use<C-b> && !inDebugRepl && vim.mode != 'Insert'";
    }

    #===== COMMAND PALETTE =====#
    # Scroll through the command palette
    {
        key = "alt+j";
        # command = "workbench.action.quickOpenNavigateNext"; #Open selection on alt released
        command = "workbench.action.quickOpenSelectNext"; #Open selection on enter pressed
        when = "inQuickOpen";
    }
    {
        key = "alt+k";
        # command = "workbench.action.quickOpenNavigatePrevious";
        command = "workbench.action.uickOpenSelectPrevious";
        when = "inQuickOpen";
    }
    {
        key = "alt+shift+j";
        # Go backwards in the quick open dialog if theres a back button
        # (e.g. When selecting dev containers options)
        command = "workbench.action.quickInputBack";
        when = "inQuickOpen";
    }

    #===== ACTIVITY BAR =====#
    # Open Remote Containers side bar
    {
        key = "ctrl+shift+alt+r";
        command = "targetsContainers.focus";
    }
    #Open Docker side bar
    {
        key = "ctrl+shift+alt+d";
        command = "dockerContainers.focus";
    }
    #Scroll through the activity bar entries
    {
        key = "ctrl+alt+y";
        command = "workbench.action.nextSideBarView";
        when = "sideBarVisible";
    }
    {
        key = "ctrl+alt+e";
        # command = "workbench.action.quickOpenNavigatePrevious";
        command = "workbench.action.previousSideBarView";
        when = "sideBarVisible";
    }

    #===== FILE EXPLORER =====#
    #Add new file/folder
    {
        key = "shift+o";
        command = "explorer.newFolder";
        when = "explorerViewletFocus && filesExplorerFocus && !inputFocus";
    }
    {
        key = "o";
        command = "explorer.newFile";
        when = "explorerViewletFocus && filesExplorerFocus && !inputFocus";
    }
    #Compare file diffs
    {
        key = "c";
        command = "selectForCompare";
        when = "explorerViewletFocus && filesExplorerFocus && !inputFocus";
    }
    {
        key = "shift+c";
        command = "compareFiles";
        when = "explorerViewletFocus && filesExplorerFocus && resourceSelectedForCompare && !inputFocus";
    }
    #Modify files
    {
        key = "y";
        command = "filesExplorer.copy";
        when = "filesExplorerFocus && filesExplorerFocus && !inputFocus";
    }
    {
        key = "r";
        command = "renameFile";
        when = "filesExplorerFocus && filesExplorerFocus && !inputFocus";
    }
    {
        key = "x";
        command = "filesExplorer.cut";
        when = "filesExplorerFocus && filesExplorerFocus && !inputFocus";
    }
    {
        key = "p";
        command = "filesExplorer.paste";
        when = "filesExplorerFocus && filesExplorerFocus && !inputFocus";
    }

    #===== INTELLISENSE =====#
    # Scroll through intellisense
    {
        key = "alt+j";
        # command = "workbench.action.quickOpenNavigateNext"; #Open selection on alt released
        command = "selectNextSuggestion"; #Open selection on enter pressed
        when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
    }
    {
        key = "alt+k";
        # command = "workbench.action.quickOpenNavigatePrevious";
        command = "selectPrevSuggestion";
        when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
    }

    #===== TERMINAL =====#
    #Toggle terminal visibility
    {
        key = "ctrl+shift+l";
        command = "workbench.action.terminal.focus";
        when = "!terminalFocus";
    }
    {
        key = "ctrl+shift+l";
        # command = "workbench.action.terminal.toggleTerminal"; #Also hides the terminal when switching focus to the editor
        command = "workbench.action.focusActiveEditorGroup";
        when = "terminalFocus";
    }
    {
        key = "shift+alt+l";
        # command = "workbench.action.terminal.toggleTerminal"; #Also hides the terminal when switching focus to the editor
        command = "workbench.action.terminal.split";
        when = "terminalFocus";
    }
    #Scroll through terminal tab groups
    {
        key = "ctrl+shift+j";
        command = "workbench.action.terminal.focusNext";
    }
    {
        key = "ctrl+shift+k";
        command = "workbench.action.terminal.focusPrevious";
    }
    #Scroll within terminal group tabs
    {
        key = "shift+alt+j";
        command = "workbench.action.terminal.focusNextPane";
    }
    {
        key = "shift+alt+k";
        command = "workbench.action.terminal.focusPreviousPane";
    }
    #Customize terminal icons
    {
        key = "ctrl+alt+shift+j";
        command = "workbench.action.terminal.changeColor";
        when = "inQuickOpen";
    }
    {
        key = "ctrl+alt+shift+j";
        command = "workbench.action.terminal.changeIcon";
        # command = "workbench.action.acceptSelectedQuickOpenItem";
        when = "!inQuickOpen";
    }
    # {
        # key = "ctrl+alt+shift+j";
        # command = "extension.multiCommand.execute";
        # when = "inQuickOpen";
        # args = {
        #     sequence = [
        #         {
        #             command = "workbench.action.terminal.changeIcon";
        #             # onDone = [
        #             #     "workbench.action.terminal.changeColor"
        #             # ]
        #         }
        #     ]
        # }
    # }
    #Create new terminal and select profile
    {
        key = "ctrl+alt+shift+k";
        command = "workbench.action.terminal.newWithProfile";
    }

    #===== JUPYTER NOTEBOOK =====#
    #Scroll through cells
    {
        key = "alt+j";
        command = "notebook.focusNextEditor";
        when = "notebookEditorFocused && !suggestWidgetMultipleSuggestions && !suggestWidgetVisible";
    }
    {
        key = "alt+k";
        command = "notebook.focusPreviousEditor";
        when = "notebookEditorFocused && !suggestWidgetMultipleSuggestions && !suggestWidgetVisible";
    }
    #Delete current cell
    {
        key = "alt+x";
        command = "notebook.cell.delete";
        when = "notebookEditorFocused";
    }
    #Add new cell
    {
        key = "alt+o";
        command = "notebook.cell.insertCodeCellBelow";
        when = "notebookEditorFocused";
    }
    {
        key = "alt+shift+o";
        command = "notebook.cell.insertCodeCellAbove";
        when = "notebookEditorFocused";
    }
    #Page scroll up/down
    {
        key = "ctrl+e";
        command = "extension.multiCommand.execute";
        when = "notebookEditorFocused";
        # args = {
        #     sequence = [{
        #                 command = "list.scrollDown";
        #                 repeat = 5
        #             }]
        # }
    }
    {
        key = "ctrl+y";
        command = "extension.multiCommand.execute";
        when = "notebookEditorFocused";
        # args = {
        #     sequence = [{
        #             command = "list.scrollUp";
        #             repeat = 5
        #         }]
        # }
    }
    {
        key = "alt+shift+g";
        command = "list.focusLast";
        when = "notebookEditorFocused";
    }
    {
        key = "alt+g alt+g";
        command = "list.focusFirst";
        when = "notebookEditorFocused";
    }
    #Move between tabs when no code cell is in focus
    {
        key = "g shift+t";
        command = "workbench.action.previousEditorInGroup";
        when = "notebookEditorFocused && !notebookCellEditorFocused";
    }
    {
        key = "g t";
        command = "workbench.action.nextEditorInGroup";
        when = "notebookEditorFocused && !notebookCellEditorFocused";
    }
    #Position cell centered on the screen
    {
        key = "z z";
        command = "notebook.centerActiveCell";
        when = "notebookEditorFocused && !notebookCellEditorFocused";
    }
    #Disable deletion of current code cell by VsVim
    {
        key = "d d";
        command = "";
        when = "notebookEditorFocused && !notebookCellEditorFocused";
    }

    #===== SIDE PANEL =====#
    #Toggle panel position
    {
        key = "ctrl+alt+shift+l";
        command = "workbench.action.positionPanelRight";
    }
    {
        key = "ctrl+alt+shift+l";
        command = "workbench.action.positionPanelBottom";
        when = "panelPosition == right";
    }

    #===== WINDOW =====#
    #Disable close window
    {
        key = "ctrl+shift+w";
        command = "-workbench.action.closeWindow";
    }
    #===== NOTIFICATIONS =====#
    {
        key = "ctrl+shift+w";
        command = "notifications.clearAll";
    }
    {
        key = "shift+alt+enter";
        command = "github.copilot.generate";
        when = "editorTextFocus && github.copilot.activated";
    }
    {
        key = "ctrl+enter";
        command = "-github.copilot.generate";
        when = "editorTextFocus && github.copilot.activated";
    }
    {
        key = "ctrl+shift+alt+g";
        command = "workbench.view.extension.copilot-labs";
    }
    {
        key = "ctrl+tab";
        command = "-workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup";
        when = "!activeEditorGroupEmpty";
    }
    {
        key = "ctrl+shift+tab";
        command = "-workbench.action.quickOpenLeastRecentlyUsedEditorInGroup";
        when = "!activeEditorGroupEmpty";
    }
    {
        key = "ctrl+tab";
        command = "workbench.action.nextEditor";
    }
    {
        key = "ctrl+pagedown";
        command = "-workbench.action.nextEditor";
    }
    {
        key = "ctrl+shift+tab";
        command = "workbench.action.previousEditor";
    }
    {
        key = "ctrl+pageup";
        command = "-workbench.action.previousEditor";
    }

    #===== BREADCRUMBS =====#
    {
        key = "ctrl+shift+;";
        command = "breadcrumbs.focusAndSelect";
        when = "editorFocus";
    }
    {
        key = "ctrl+shift+;";
        # Focus the editor
        command = "workbench.action.focusActiveEditorGroup";
        when = "!editorFocus";
    }
    {
        key = "shift+j";
        command = "breadcrumbs.focusPrevious";
        when = "breadcrumbsActive && breadcrumbsVisible";
    }
    {
        key = "shift+k";
        command = "breadcrumbs.focusNext";
        when = "breadcrumbsActive && breadcrumbsVisible";
    }
    {
        key = "ctrl+p";
        command = "-extension.vim_ctrl+p";
        when = "editorTextFocus && vim.active && vim.use<C-p> && !inDebugRepl || vim.active && vim.use<C-p> && !inDebugRepl && vim.mode == 'CommandlineInProgress' || vim.active && vim.use<C-p> && !inDebugRepl && vim.mode == 'SearchInProgressMode'";
    }
]