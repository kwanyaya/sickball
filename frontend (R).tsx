import { useEffect, useState } from 'react'

interface Book {
  id: string,
  name: string,
  tags: string[]
}

async function fetchAllBooks() {
  const list: Book[] = [
    { id: '1', name: 'xxx', tags: ['tag1', 'tag2'] },
    { id: '2', name: 'xxx2', tags: ['tag3', 'tag4'] },
  ]
  return list
}

export default function MyPage() {
  const [books, setBooks] = useState<Book[]>([])

  // Fetch all books on mount
  useEffect(() => {
    fetchAllBooks().then((data) => setBooks(data))
  }, [])

  const [page, setPage] = useState(1)
  const [keyword, setKeyword] = useState('')
  const [tagFilters, setTagFilters] = useState<string[]>([])

  // Reset to page 1 whenever filters change
  useEffect(() => {
    setPage(1)
  }, [keyword, tagFilters])

  // Filter books locally based on keyword and tag filters
  const shownItems: Book[] = books.filter((book) => {
    const matchesKeyword = keyword.trim() === '' ||
      book.name.toLowerCase().includes(keyword.trim().toLowerCase())

    const matchesTags = tagFilters.length === 0 ||
      tagFilters.every((tag) => book.tags.includes(tag))

    return matchesKeyword && matchesTags
  })

  // ... no need to write the UI part
}