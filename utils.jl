function hfun_bar(vname)
  val = Meta.parse(vname[1])
  return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end

function lx_baz(com, _)
  # keep this first line
  brace_content = Franklin.content(com.braces[1]) # input string
  # do whatever you want here
  return uppercase(brace_content)
end

function _escape_html(s::AbstractString)
  return replace(s, "&" => "&amp;", "<" => "&lt;", ">" => "&gt;", "\"" => "&quot;")
end

function _format_authors(raw::AbstractString)
  parts = [strip(p) for p in split(raw, " and ") if !isempty(strip(p))]
  if length(parts) <= 1
    return raw
  elseif length(parts) == 2
    return string(parts[1], " and ", parts[2])
  else
    head = join(parts[1:end-2], ", ")
    return string(head, ", ", parts[end-1], " and ", parts[end])
  end
end

function _primary_author_lastname(raw::AbstractString)
  parts = [strip(p) for p in split(raw, " and ") if !isempty(strip(p))]
  if isempty(parts)
    return ""
  end
  first_author = parts[1]
  if occursin(",", first_author)
    return strip(split(first_author, ",")[1])
  end
  tokens = [t for t in split(first_author) if !isempty(t)]
  return isempty(tokens) ? "" : tokens[end]
end

function _year_as_int(raw::AbstractString)
  y = tryparse(Int, strip(raw))
  return y === nothing ? typemax(Int) : y
end

const _working_paper_types = Set(["workingpaper", "techreport", "misc"])

function _read_working_papers(path::AbstractString)
  text = read(path, String)
  entries = Vector{Dict{String, String}}()
  buf = IOBuffer()
  depth = 0
  for c in text
    if c == '@' && depth == 0
      if position(buf) > 0
        entry = String(take!(buf))
        if !isempty(strip(entry))
          parsed = _parse_bib_entry(entry)
          if !isempty(parsed)
            push!(entries, parsed)
          end
        end
      end
    end
    if c == '{'
      depth += 1
    elseif c == '}'
      depth = max(depth - 1, 0)
    end
    write(buf, c)
  end
  if position(buf) > 0
    entry = String(take!(buf))
    if !isempty(strip(entry))
      parsed = _parse_bib_entry(entry)
      if !isempty(parsed)
        push!(entries, parsed)
      end
    end
  end
  return entries
end

function _parse_bib_entry(entry::AbstractString)
  fields = Dict{String, String}()
  type_match = match(r"@\s*(\w+)\s*\{", entry)
  if type_match === nothing
    return fields
  end
  entry_type = lowercase(type_match.captures[1])
  if entry_type in ["string", "preamble", "comment"]
    return fields
  end
  fields["_type"] = entry_type
  for m in eachmatch(r"(\w+)\s*=\s*(\{[^}]*\}|\"[^\"]*\")\s*,?", entry)
    key = lowercase(m.captures[1])
    val = m.captures[2]
    val = strip(val)
    if startswith(val, "{") && endswith(val, "}")
      val = val[2:end-1]
    elseif startswith(val, "\"") && endswith(val, "\"")
      val = val[2:end-1]
    end
    fields[key] = strip(val)
  end
  return fields
end

function hfun_working_papers()
  return hfun_working_papers(String[])
end

function hfun_working_papers(params)
  filename = isempty(params) ? "working_papers.bib" : params[1]
  path = joinpath(pwd(), "bibliography", filename)
  if !isfile(path)
    return "<p><em>No working papers found.</em></p>"
  end
  entries = filter(entry -> get(entry, "_type", "") in _working_paper_types,
                   _read_working_papers(path))
  sort!(entries, by = e -> (lowercase(_primary_author_lastname(get(e, "author", ""))),
                            _year_as_int(get(e, "year", ""))))
  if isempty(entries)
    return "<p><em>No working papers found.</em></p>"
  end
  io = IOBuffer()
  write(io, "<ol class=\"working-papers\">")
  for entry in entries
    title = get(entry, "title", "")
    authors = get(entry, "author", "")
    year = get(entry, "year", "")
    note = get(entry, "note", "")
    url = get(entry, "url", "")
    write(io, "<li>")
    if !isempty(authors)
      write(io, _escape_html(_format_authors(authors)), ". ")
    end
    if !isempty(title)
      if !isempty(url)
        write(io, "<a href=\"", _escape_html(url), "\">", _escape_html(title), "</a>")
      else
        write(io, _escape_html(title))
      end
    end
    if !isempty(year)
      write(io, " (", _escape_html(year), ")")
    end
    if !isempty(note)
      write(io, ". ", _escape_html(note))
    end
    write(io, "</li>")
  end
  write(io, "</ol>")
  return String(take!(io))
end
