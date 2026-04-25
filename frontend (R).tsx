import { useEffect, useState } from 'react'

// Task Description: 
// This is a listing page of books.
// When the page is loaded, it fetches all books into a variable, called "books"
// Then user will do some searching, by typing some keywords or some tags
// The page will do the filtering locally and then store the result into a variable, called "shownItems"

// finish those "to do" parts
// p.s., you can add any other variables or functions you need

interface Book {
  id: string,
  name: string,
  tags: string[]
  // ... others
}

async function fetchAllBooks() {
  const list: Book[] = [
    { id: '1', name: 'xxx', tags: ['tag1', 'tag2'] },
    { id: '2', name: 'xxx2', tags: ['tag3', 'tag4'] },
    // ...
  ]
  return list
}

export default function MyPage() {
  const [books, setBooks] = useState<Book[]>()
  useEffect(() => {
    fetchAllBooks().then(setBooks)
  }, []) // to do
  
  const [page, setPage] = useState(1)
  const [keyword, setKeyword] = useState('')
  const [tagFilters, setTagFilters] = useState<string[]>([])
  const [filteredBooks, setFilteredBooks] = useState<Book[]>([])
  useEffect(() => {
    const filtered = (books ?? []).filter(book => {
      const matchesKeyword = book.name.toLowerCase().includes(keyword.toLowerCase())
      const matchesTags = tagFilters.length === 0 || tagFilters.every(tag => book.tags.includes(tag))
      return matchesKeyword && matchesTags
    })
    setFilteredBooks(filtered)
  }, [books, keyword, tagFilters, page]) // to do

  const shownItems: Book[] = filteredBooks // to do

  // ... no need to write the UI part
}