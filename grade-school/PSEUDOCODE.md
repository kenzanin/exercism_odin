# Grade School pseudocode (near-Odin syntax)

```odin
package grade_school

import "core:map"   // for associative tables
import "core:sort"  // for sorting grade ids and names

School :: struct {
    // map grade -> sorted list of student names
    roster_by_grade: map[u8][]string,
    // map student name -> grade (prevents duplicate across grades)
    student_grade:   map[string]u8,
}

delete_school :: proc(self: ^School) {
    // release owned slices and maps
    for _, names in self.roster_by_grade {
        delete(names)
    }
    delete(self.roster_by_grade)
    delete(self.student_grade)
    *self = School{} // reset struct fields
}

// Add a student to a grade, keeping data canonical.
// Return false if student already exists in any grade.
add :: proc(self: ^School, student: string, grade: u8) -> bool {
    if self.roster_by_grade == nil {
        self.roster_by_grade = make(map[u8][]string)
    }
    if self.student_grade == nil {
        self.student_grade = make(map[string]u8)
    }

    // Reject duplicates: same grade or another grade
    if _, ok := self.student_grade[student]; ok {
        return false
    }

    names := self.roster_by_grade[grade]
    if names == nil {
        names = make([]string, 0, 1)
    }

    // Insert student in alphabetical order
    insert_index := 0
    for i in 0 ..< len(names) {
        if student < names[i] {
            break
        }
        insert_index = i + 1
    }
    names = append(names, "")          // grow slice
    copy(names[insert_index+1:], names[insert_index:])
    names[insert_index] = student

    self.roster_by_grade[grade] = names
    self.student_grade[student] = grade
    return true
}

// Return sorted list of names for a grade; empty slice if none.
grade :: proc(self: ^School, id: u8) -> []string {
    names := self.roster_by_grade[id]
    if names == nil {
        return []string{}
    }
    result := make([]string, len(names))
    copy(result, names)
    return result
}

// Return full roster sorted by grade ascending, names already sorted.
roster :: proc(self: ^School) -> []Grade {
    if len(self.roster_by_grade) == 0 {
        return []Grade{}
    }

    // collect and sort grade ids
    keys := make([]u8, 0, len(self.roster_by_grade))
    for id, _ in self.roster_by_grade {
        keys = append(keys, id)
    }
    sort.ascending(keys) // sorts in place

    grades := make([]Grade, 0, len(keys))
    for _, id in keys {
        names := self.roster_by_grade[id]
        copy_names := make([]string, len(names))
        copy(copy_names, names)
        grades = append(grades, Grade{id, copy_names})
    }
    return grades
}
```

Notes:
- `student_grade` map stops the same name from being added again (either to same or different grade).
- Names are inserted in-order on add, so later reads don’t need extra sorting.
- `grade`/`roster` return copies of slices to avoid accidental external mutation of internal state.
- `delete_school` releases slices/maps; tests call it in `defer`.
